use std::path::Path;

use std::process::Command;

use std::fs;

fn main() {
    let cuda_lib_dir = match option_env!("CUDA_LIB_DIR") {
        Some(s) => s,
        None => "/opt/cuda/lib64", // reasonable default. works on arch!
    };

    let cuda_code_dir = Path::new(env!("CARGO_MANIFEST_DIR")).join("logmin-cuda");

    let c_archive_dir = Path::new(env!("OUT_DIR")).join("logmin-cuda");

    match fs::metadata(&c_archive_dir) {
        Ok(_) => (),
        Err(_) => {
            fs::create_dir(&c_archive_dir).unwrap() // panics if there are permissions errors
        },
    }

    Command::new("make")
        .arg("liblogmin")
        .current_dir(&cuda_code_dir)
        .env("CARGO_BUILD_DIR", &c_archive_dir)
        .output().unwrap();

    println!("cargo:rustc-link-search=native={}", c_archive_dir.display());
    println!("cargo:rustc-link-search=native={}", cuda_lib_dir);
    println!("cargo:rustc-link-lib=dylib=stdc++");
    println!("cargo:rustc-link-lib=dylib=cudart");
}
