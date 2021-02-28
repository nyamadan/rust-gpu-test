Push-Location ".\rust-gpu\crates\rustc_codegen_spirv"
$env:RUSTFLAGS=""
cargo build --release
Pop-Location

Copy-Item ".\rust-gpu\target\release\rustc_codegen_spirv.dll" ".\rustc_codegen_spirv.dll"
$env:RUSTFLAGS="-Z codegen-backend=$(Get-Location)\rustc_codegen_spirv.dll -Z symbol-mangling-version=v0 -C target-feature=+spirv1.0"
cargo build -Z build-std=core --target spirv-unknown-unknown --release

$env:RUSTFLAGS=""
