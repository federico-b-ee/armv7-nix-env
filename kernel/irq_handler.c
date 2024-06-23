#include "inc/gic.h"
#include "inc/sched.h"
#include "inc/timer.h"

// CTX should have a struct that reflects the pushed data inside the
// asm_irq_handler
__attribute__((section(".text"))) uint32_t c_irq_handler(uint32_t *ctx) {
  _gicc_t *const GICC0 = (_gicc_t *)GICC0_ADDR;
  _timer_t *const TIMER0 = (_timer_t *)TIMER0_ADDR;
  uint32_t id = GICC0->IAR;

  switch (id) {
  case GIC_SOURCE_TIMER0:
    TIMER0->Timer1IntClr = 0x1;
    c_systick_handler();
    break;

  default:
    break;
  }
  GICC0->EOIR = id;
  return id;
}
