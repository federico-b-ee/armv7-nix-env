#include "inc/sched.h"
#include "inc/tasks.h"
#include <stddef.h>

static volatile _systick_t systick = 0;

__attribute__((section(".text"))) void c_systick_handler() { systick++; }

__attribute__((section(".text"))) _systick_t c_systick_get() { return systick; }

__attribute__((section(".text"))) void c_delay(_systick_t ticks) {
  _systick_t start = systick;
  while (systick - start < ticks) {
  }
}

static _task_t tasks[MAX_TASKS];
static uint8_t task_index = 0;
static _task_t *current_task = NULL;

/* Stack pointers for tasks */
extern uint32_t __task0_sp;
extern uint32_t __task1_sp;
extern uint32_t __task2_sp;
extern uint32_t __task3_sp;
uint32_t *task_sp[] = {&__task0_sp, &__task1_sp, &__task2_sp, &__task3_sp};

/* IRQ stack pointers for tasks */
extern uint32_t __task0_irq_sp;
extern uint32_t __task1_irq_sp;
extern uint32_t __task2_irq_sp;
extern uint32_t __task3_irq_sp;
uint32_t *task_irq_sp[] = {&__task0_irq_sp, &__task1_irq_sp, &__task2_irq_sp,
                           &__task3_irq_sp};

__attribute__((section(".text"))) void c_task_init(_task_ptr_t entrypoint,
                                                   _systick_t ticks) {
  if (task_index < MAX_TASKS) {
    tasks[task_index].id = task_index;
    tasks[task_index].entrypoint = entrypoint;
    tasks[task_index].task_ticks = ticks;
    tasks[task_index].current_ticks = 0u;
    /* Set stack pointer for task */
    tasks[task_index].sp = task_sp[task_index];
    /* Set IRQ stack pointer for task */
    tasks[task_index].irq_sp = task_irq_sp[task_index];
    task_index++;
  }
}

__attribute__((section(".text"))) void c_predefined_tasks_init(void) {
  c_task_init(task_idle, 5u);
  c_task_init(task1, 8u);
  c_task_init(task2, 12u);
  c_task_init(task3, 5u);
  current_task = &tasks[0];
  current_task->entrypoint();
}

__attribute__((section(".text"))) uint32_t c_scheduler(_ctx_t *ctx) {
  c_puts_hex(current_task->current_ticks);
  c_puts("\n");
  current_task->current_ticks++;
  if (current_task->current_ticks >= current_task->task_ticks) {
    // Context Switch -- Push tasks' state
    // Assuming the stack has a context struct
    // TODO! revise this
    uint32_t *task_stack = current_task->sp;
    for (int i = 0; i < 13; i++) {
      // Save registers
      task_stack[i] = ctx->registers[i];
    }
    // Save SP
    task_stack[13] = ctx->sp;
    // Save SPSR
    task_stack[14] = ctx->spsr;
    // Save LR
    task_stack[15] = ctx->lr;
    // Set counter to zero
    current_task->current_ticks = 0;

    // Change the task_id by 1 and wrap around
    uint8_t id = current_task->id;
    id++;
    id %= MAX_TASKS;
    // Set the current task to the new task_id
    current_task = &tasks[id];

    // Context Switch -- Pop tasks' state
    uint32_t *next_task_stack = current_task->sp;
    for (int i = 0; i < 13; i++) {
      // Restore registers
      ctx->registers[i] = next_task_stack[i];
    }
    // Restore SP
    ctx->sp = next_task_stack[13];
    // Restore SPSR
    ctx->spsr = next_task_stack[14];
    // Restore LR
    ctx->lr = next_task_stack[15];
    current_task->entrypoint();
    c_puts("BEG -- Task Switch\n");
    c_puts_hex(current_task->id);
    c_puts("\nEND -- Task Switch\n");
  }
  return 0;
}
