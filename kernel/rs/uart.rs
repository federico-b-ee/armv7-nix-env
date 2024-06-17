// uart.rs

#![allow(dead_code)]

const UART0_ADDR: u32 = 0x10009000;

const FR_BUSY: u32 = 1 << 3;
const LCRH_FEN: u32 = 1 << 4;
const CR_UARTEN: u32 = 1 << 0;
const FR_RXFE: u32 = 1 << 4;
const FR_TXFF: u32 = 1 << 5;

#[allow(non_snake_case)]
#[repr(C)]
struct UART {
    DR: u32,
    RSRECR: u32,
    RESERVED0: [u32; 4],
    FR: u32,
    RESERVED1: u32,
    ILPR: u32,
    IBRD: u32,
    FBRD: u32,
    LCRH: u32,
    CR: u32,
}

#[no_mangle]
#[link_section = ".text"]
pub unsafe extern "C" fn __rs_UART0_init() {
    let uart0 = &mut *(UART0_ADDR as *mut UART);

    // Disable UART0.
    uart0.CR &= !CR_UARTEN;
    while (uart0.FR & FR_BUSY) != 0 {}
    uart0.LCRH &= !LCRH_FEN;

    // Set baud rate to 115200:
    // PrimeCell® UART (PL011) Technical Reference Manual Page 56 // 3-10
    // Baud Rate Divisor = (24E6)/(16×115200) = 13.0208333
    // This means BRDI = 13 and BRD F = 0.020833.
    // Therefore, fractional part, m = integer((0.020833×64)+0.5) = int(1.833) = 1

    uart0.IBRD = 13;
    uart0.FBRD = 1;

    // Set word size to 8 bits, no parity, one stop bit (8-N-1).
    uart0.LCRH |= 0b11 << 5; // WLEN
    uart0.LCRH &= !(1 << 1); // PEN
    uart0.LCRH &= !(1 << 2); // EPS
    uart0.LCRH &= !(1 << 7); // SPS
    uart0.LCRH &= !(1 << 3); // STP2

    uart0.LCRH |= LCRH_FEN;

    uart0.CR |= CR_UARTEN;
}

#[no_mangle]
#[link_section = ".text"]
pub unsafe extern "C" fn rs_putchar(c: u8) {
    let uart0 = &mut *(UART0_ADDR as *mut UART);
    while (uart0.FR & FR_TXFF) != 0 {} // Wait until the TX FIFO is not full.
    uart0.DR = c as u32;
}

#[no_mangle]
#[link_section = ".text"]
pub unsafe extern "C" fn rs_putstr(s: *const u8) {
    let mut ptr = s;
    while *ptr != 0 {
        rs_putchar(*ptr);
        ptr = ptr.add(1);
    }
}
