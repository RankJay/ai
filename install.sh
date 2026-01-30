#!/usr/bin/env bash
set -euo pipefail

# Constants
REPO="RankJay/ai"
GITHUB_API="https://api.github.com/repos/${REPO}/releases/latest"
DEFAULT_INSTALL_DIR="${HOME}/.local/bin"
BINARY_NAME="ai-init"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Platform detection
detect_platform() {
    case "$(uname -s)" in
        Linux*) echo "linux" ;;
        Darwin*) echo "darwin" ;;
        *) echo "unsupported" ;;
    esac
}

# Architecture detection
detect_architecture() {
    case "$(uname -m)" in
        x86_64) echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        *) echo "unsupported" ;;
    esac
}

# Get asset name for platform
get_asset_name() {
    local os="$1"
    local arch="$2"
    echo "ai-init-${os}-${arch}"
}

# Prompt for installation directory
prompt_install_dir() {
    local default="$1"
    echo -n "Installation directory [${default}]: " >&2
    read -r user_input
    if [ -z "$user_input" ]; then
        echo "$default"
    else
        echo "$user_input"
    fi
}

# Check if ai-init is already installed
check_existing_installation() {
    local install_dir="$1"
    [ -f "${install_dir}/${BINARY_NAME}" ]
}

# Prompt user for upgrade
prompt_upgrade() {
    local install_path="$1"
    echo -e "${YELLOW}ai-init is already installed at ${install_path}${NC}" >&2
    echo -n "Upgrade? [Y/n]: " >&2
    read -r response
    case "$response" in
        [Nn]*) return 1 ;;
        *) return 0 ;;
    esac
}

# Download file using curl or wget
download_file() {
    local url="$1"
    local output="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$output"
    else
        echo -e "${RED}Error: curl or wget required${NC}" >&2
        exit 1
    fi
}

# Verify SHA256 checksum
verify_checksum() {
    local binary_path="$1"
    local checksums_path="$2"
    local asset_name=$(basename "$binary_path")
    local expected_hash=$(grep "$asset_name" "$checksums_path" | awk '{print $1}')
    local actual_hash=$(sha256sum "$binary_path" | awk '{print $1}')
    [ "$expected_hash" = "$actual_hash" ]
}

# Detect available shells
detect_shells() {
    local shells=()
    [ -f "${HOME}/.bashrc" ] && shells+=("bash")
    [ -f "${HOME}/.zshrc" ] && shells+=("zsh")
    [ -f "${HOME}/.config/fish/config.fish" ] && shells+=("fish")
    echo "${shells[@]}"
}

# Update shell configuration file
update_shell_config() {
    local shell="$1"
    local install_dir="$2"
    local config_file=""
    local path_line=""
    
    case "$shell" in
        bash)
            config_file="${HOME}/.bashrc"
            path_line="export PATH=\"${install_dir}:\$PATH\""
            ;;
        zsh)
            config_file="${HOME}/.zshrc"
            path_line="export PATH=\"${install_dir}:\$PATH\""
            ;;
        fish)
            config_file="${HOME}/.config/fish/config.fish"
            path_line="set -gx PATH ${install_dir} \$PATH"
            ;;
    esac
    
    if [ -n "$config_file" ]; then
        # Check if ai-init PATH is already configured
        # Look for either the exact path or $HOME/.local/bin pattern
        local dir_pattern=$(echo "$install_dir" | sed 's/[.*+?^${}()|[\]\\]/\\&/g')
        local home_pattern="\\\$HOME/.local/bin"
        
        if ! grep -qE "# ai-init" "$config_file" 2>/dev/null || \
           ! grep -qE "(PATH.*${dir_pattern}|PATH.*${home_pattern})" "$config_file" 2>/dev/null; then
            mkdir -p "$(dirname "$config_file")"
            echo "" >> "$config_file"
            echo "# ai-init" >> "$config_file"
            # Use $HOME for .local/bin for portability, otherwise use exact path
            if [ "$install_dir" = "${HOME}/.local/bin" ]; then
                echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$config_file"
            else
                echo "$path_line" >> "$config_file"
            fi
            echo -e "${GREEN}Updated ${config_file}${NC}"
        else
            echo -e "${GREEN}PATH already configured in ${config_file}${NC}"
        fi
    fi
}

# Verify installation works
verify_installation() {
    local install_dir="$1"
    local binary_path="${install_dir}/${BINARY_NAME}"
    
    if [ ! -f "$binary_path" ]; then
        echo -e "${RED}Error: Binary not found at ${binary_path}${NC}" >&2
        exit 1
    fi
    
    if ! "$binary_path" --version >/dev/null 2>&1; then
        echo -e "${RED}Error: Installation verification failed. ai-init may not be working correctly.${NC}" >&2
        exit 1
    fi
}

# Main installation function
main() {
    echo "Installing ai-init..."
    echo ""
    
    # 1. Detect platform and architecture
    local platform=$(detect_platform)
    local arch=$(detect_architecture)
    
    if [ "$platform" = "unsupported" ]; then
        echo -e "${RED}Error: Unsupported platform: $(uname -s)${NC}" >&2
        exit 1
    fi
    
    if [ "$arch" = "unsupported" ]; then
        echo -e "${RED}Error: Unsupported architecture: $(uname -m)${NC}" >&2
        exit 1
    fi
    
    echo -e "${GREEN}Detected platform: ${platform} (${arch})${NC}"
    
    # 2. Get installation directory
    local install_dir=$(prompt_install_dir "$DEFAULT_INSTALL_DIR")
    install_dir=$(eval echo "$install_dir")  # Expand ~ and variables
    
    # 3. Check for existing installation
    if check_existing_installation "$install_dir"; then
        local install_path="${install_dir}/${BINARY_NAME}"
        if ! prompt_upgrade "$install_path"; then
            echo "Installation cancelled."
            exit 0
        fi
    fi
    
    # 4. Create installation directory
    mkdir -p "$install_dir"
    if [ ! -w "$install_dir" ]; then
        echo -e "${RED}Error: Cannot write to ${install_dir}. Check permissions.${NC}" >&2
        exit 1
    fi
    
    # 5. Get latest release info
    echo "Fetching latest release..."
    local temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT
    
    local release_info
    if command -v curl >/dev/null 2>&1; then
        release_info=$(curl -fsSL "$GITHUB_API" -H "User-Agent: ai-init-installer")
    elif command -v wget >/dev/null 2>&1; then
        release_info=$(wget -q -O- "$GITHUB_API" --header="User-Agent: ai-init-installer")
    else
        echo -e "${RED}Error: curl or wget required${NC}" >&2
        exit 1
    fi
    
    local tag_name=$(echo "$release_info" | grep -o '"tag_name":"[^"]*"' | cut -d'"' -f4)
    if [ -z "$tag_name" ]; then
        echo -e "${RED}Error: Failed to fetch latest release${NC}" >&2
        exit 1
    fi
    
    echo -e "${GREEN}Latest version: ${tag_name}${NC}"
    
    # 6. Download binary and checksums
    local asset_name=$(get_asset_name "$platform" "$arch")
    local download_url="https://github.com/${REPO}/releases/download/${tag_name}/${asset_name}"
    local checksums_url="https://github.com/${REPO}/releases/download/${tag_name}/checksums.txt"
    
    local binary_temp="${temp_dir}/${asset_name}"
    local checksums_temp="${temp_dir}/checksums.txt"
    
    echo "Downloading binary..."
    download_file "$download_url" "$binary_temp"
    
    echo "Downloading checksums..."
    download_file "$checksums_url" "$checksums_temp"
    
    # 7. Verify checksum
    echo "Verifying checksum..."
    if ! verify_checksum "$binary_temp" "$checksums_temp"; then
        echo -e "${RED}Error: Checksum verification failed. Aborting installation.${NC}" >&2
        exit 1
    fi
    echo -e "${GREEN}Checksum verified${NC}"
    
    # 8. Install binary
    echo "Installing binary..."
    mv "$binary_temp" "${install_dir}/${BINARY_NAME}"
    chmod +x "${install_dir}/${BINARY_NAME}"
    
    # 9. Remove macOS quarantine attribute if needed
    if [ "$platform" = "darwin" ]; then
        xattr -d com.apple.quarantine "${install_dir}/${BINARY_NAME}" 2>/dev/null || true
    fi
    
    # 10. Update PATH for all detected shells
    echo "Updating PATH..."
    local shells=$(detect_shells)
    if [ -z "$shells" ]; then
        echo -e "${YELLOW}Warning: No shell configuration files detected. You may need to add ${install_dir} to your PATH manually.${NC}"
    else
        for shell in $shells; do
            update_shell_config "$shell" "$install_dir"
        done
    fi
    
    # 11. Verify installation
    echo "Verifying installation..."
    verify_installation "$install_dir"
    
    # 12. Success message
    echo ""
    echo -e "${GREEN}✓ ai-init installed successfully!${NC}"
    echo ""
    echo "Installed to: ${install_dir}"
    echo "Version: $("${install_dir}/${BINARY_NAME}" --version 2>/dev/null | head -n1 || echo "unknown")"
    echo ""
    
    if [ -n "$shells" ]; then
        echo "PATH has been updated in your shell configuration files."
        echo "Please restart your terminal or run:"
        echo "  export PATH=\"${install_dir}:\$PATH\""
    else
        echo "To use ai-init, add it to your PATH:"
        echo "  export PATH=\"${install_dir}:\$PATH\""
    fi
    echo ""
    echo "Run 'ai-init --help' to get started."
}

# Run main function
main "$@"
