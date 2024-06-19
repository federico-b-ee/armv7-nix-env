#include "inc/timer.h"

__attribute__((section(".text"))) void c_timer_init() {
  _timer_t *const TIMER0 = (_timer_t *)TIMER0_ADDR;

  TIMER0->Timer1Load = 0x00010000;
  TIMER0->Timer1Ctrl = 0x00000002;
  TIMER0->Timer1Ctrl |= 0x00000040;
  TIMER0->Timer1Ctrl |= 0x00000020;
  TIMER0->Timer1Ctrl |= CTRL_IRQ_ENABLE;
}
