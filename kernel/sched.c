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

__attribute__((section(".text"))) void c_task_init(_task_ptr_t entrypoint,
                                                   _systick_t ticks) {
  if (task_index < MAX_TASKS) {
    tasks[task_index].entrypoint = entrypoint;
    tasks[task_index].ticks = ticks;
    tasks[task_index].last_run = 0;
    task_index++;
  }
}

__attribute__((section(".text"))) void c_sched_run(void) {
  while (1) {
    for (int i = 0; i < MAX_TASKS; i++) {
      _task_t *task = &tasks[i];
      if (task->entrypoint == NULL) {
        continue;
      }
      _systick_t now = c_systick_get();
      if (now - task->last_run >= tasks->ticks) {
        task->last_run = now;
        task->entrypoint();
      }
    }
  }
}

__attribute__((section(".text"))) void c_predefined_tasks_init(void) {
  c_task_init(task_idle, 5);
  c_task_init(task1, 8);
  c_task_init(task2, 12);
  c_task_init(task3, 5);
}
