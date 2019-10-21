extern crate libgreeting_sys;

use libgreeting_sys as ffi;

fn main() {
    unsafe {
        let name = std::ffi::CString::new("C++").unwrap();
        let greeting = ffi::create_Greeting(name.as_ptr());


        let hello = std::ffi::CString::new("Rust").unwrap();
        ffi::call_Greeting_Hello(greeting, hello.as_ptr());
    }
}
