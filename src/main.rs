extern crate libc;

#[link(name="logmin", kind="static")]
extern {
    fn run_logmin(array: *const libc::int64_t, array_len: libc::size_t) -> libc::int64_t;
    fn run_linmin(array: *const libc::int64_t, array_size: libc::size_t) -> libc::int64_t;
}

fn main() {
   let mut v = Vec::new();
   for i in 0..1000 {
       v.push(10289*(i+1)%20269);
   }
   let result_lin = unsafe { run_linmin(v.as_ptr(), v.len()) };
   let result_log = unsafe { run_logmin(v.as_ptr(), v.len()) };
   println!("{}\n{}", result_lin, result_log);
}
