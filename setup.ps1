if (-Not (Test-Path .cargo)) {
    New-Item -Path .cargo -ItemType Directory | Out-Null
}

if (Test-Path .cargo\config) {
    Remove-Item .cargo\config | Out-Null
}

Push-Location ".\rust-gpu\crates\rustc_codegen_spirv"
cargo build --release
Pop-Location
Copy-Item ".\rust-gpu\target\release\rustc_codegen_spirv.dll" ".\rustc_codegen_spirv.dll"

(@"
[build]
target = "spirv-unknown-unknown"
rustflags = [
   "-Zcodegen-backend={0}\\rustc_codegen_spirv.dll",
   "-Zsymbol-mangling-version=v0"
]

[unstable]
build-std=["core"]
"@ -f ((Get-Location) -replace "\\", "\\")) | Out-File -FilePath .cargo\config
