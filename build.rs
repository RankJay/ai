fn main() {
    // Embed version at compile time
    println!("cargo:rerun-if-changed=Cargo.toml");
}
