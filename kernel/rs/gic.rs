// gic.rs

#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

const GICC0_ADDR: u32 = 0x1E000000;
const GICD0_ADDR: u32 = 0x1E001000;

#[allow(non_snake_case)]
#[repr(C)]
struct GICC {
    CTLR: u32,
    PMR: u32,
    BPR: u32,
    IAR: u32,
    EOIR: u32,
    RPR: u32,
    HPPIR: u32,
}

#[allow(non_snake_case)]
#[repr(C)]
struct GICD {
    CTLR: u32,
    TYPER: u32,
    RESERVED0: [u8; 0x00FC - 0x0008 + 1],
    ISENABLER: [u32; 3],
    RESERVED1: [u8; 0x017C - 0x010C + 1],
    ICENABLER: [u32; 3],
    RESERVED2: [u8; 0x01FC - 0x018C + 1],
    ISPENDR: [u32; 3],
    RESERVED3: [u8; 0x027C - 0x020C + 1],
    ICPENDR: [u32; 3],
    RESERVED4: [u8; 0x02FC - 0x028C + 1],
    ISACTIVER: [u32; 3],
    RESERVED5: [u8; 0x03FC - 0x030C + 1],
    IPRIORITYR: [u32; 24],
    RESERVED6: [u8; 0x07FC - 0x0460 + 1],
    ITARGETSR: [u32; 24],
    RESERVED7: [u8; 0x0BFC - 0x0860 + 1],
    ICFGR: [u32; 6],
    RESERVED8: [u8; 0x0EFC - 0x0C18 + 1],
    SGIR: u32,
    RESERVED9: [u8; 0x0FFC - 0x0F04 + 1],
}

#[no_mangle]
#[link_section = ".text"]
pub unsafe extern "C" fn __gic_init() {
    let gicc0 = &mut *(GICC0_ADDR as *mut GICC);
    let gicd0 = &mut *(GICD0_ADDR as *mut GICD);

    gicc0.PMR = 0x000000F0;
    gicd0.ISENABLER[1] |= 0x00000010;
    gicd0.ISENABLER[1] |= 0x00001000;
    gicc0.CTLR = 0x00000001;
    gicd0.CTLR = 0x00000001;
}
