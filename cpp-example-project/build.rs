extern crate bindgen;
extern crate cc;

use std::env;
use std::path::PathBuf;

fn build_greeting() {
    let mut config = cc::Build::new();
    config.include("cpp/");
    config.file("cpp/greeting.cpp");
    config.file("cpp/c.cpp");
    config.cpp(true);
    config.compile("libgreeting.a");
}

fn main() {
    build_greeting();

    println!("cargo:rustc-link-lib=greeting");
    println!("cargo:rerun-if-changed=cpp/");

    let bindings = bindgen::Builder::default()
        .header("cpp/c.h")
//        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}