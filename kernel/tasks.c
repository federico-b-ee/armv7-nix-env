#include "inc/tasks.h"
#include "inc/sched.h"
#include "inc/uart.h"

static uint32_t global0_var = 0;
static uint32_t global1_var = 0xFFFFFFFF;

void task_idle() {
  c_putsln("Task idle");
  while (1) {
    asm("wfi");
  }
}

void task1() {
  while (1) {
    static uint32_t local_var = 0;
    _systick_t now = c_systick_get();
    c_puts("Task 0, systicks: ");
    c_puts_hex(now);
    c_putsln("");
    c_puts("local_var = ");
    c_puts_hex(local_var);
    c_putsln("");

    local_var++;
    global0_var++;

    c_puts("Task 0 finished, systicks: ");
    now = c_systick_get();
    c_puts_hex(now);
    c_putsln("");
    c_puts("local_var = ");
    c_puts_hex(local_var);
    c_putsln("");
    c_puts("global0_var = ");
    c_puts_hex(global0_var);
    c_putsln("");
  }
}

void task2() {
  while (1) {
    static uint32_t local_var = 0xFFFFFFFF;
    _systick_t now = c_systick_get();
    c_puts("Task 2, systicks: ");
    c_puts_hex(now);
    c_putsln("");
    c_puts("local_var = ");
    c_puts_hex(local_var);
    c_putsln("");

    local_var--;
    global1_var--;
    while (now + 100u > c_systick_get())
      ;

    c_puts("Task 2 finished, systicks: ");
    now = c_systick_get();
    c_puts_hex(now);
    c_putsln("");
    c_puts("local_var = ");
    c_puts_hex(local_var);
    c_putsln("");
    c_puts("global1_var = ");
    c_puts_hex(global1_var);
    c_putsln("");
  }
}

void task3() {
  while (1) {
    _systick_t now = c_systick_get();
    c_puts("Task 3, systicks: ");
    c_puts_hex(now);
    c_putsln("");

    global1_var++;
    global0_var--;

    c_puts("Task 3 finished, systicks: ");
    now = c_systick_get();
    c_puts_hex(now);
    c_putsln("");
    c_puts("global0_var = ");
    c_puts_hex(global0_var);
    c_putsln("");
    c_puts("global1_var = ");
    c_puts_hex(global1_var);
    c_putsln("");
  }
}
