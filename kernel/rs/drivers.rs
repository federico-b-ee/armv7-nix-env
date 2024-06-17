#![no_std]
#![no_main]

mod gic;
mod uart;

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
