#ifndef __SCHED_H__
#define __SCHED_H__

#include <stdint.h>

typedef uint32_t _systick_t;

// Function Definitions
void c_systick_handler();
_systick_t c_systick_get();
void c_delay(_systick_t ticks);

// Task Definitions

typedef void (*_task_ptr_t)(void);

typedef struct {
  _task_ptr_t entrypoint;
  _systick_t ticks;
  _systick_t last_run;
} _task_t;

#define MAX_TASKS 4u

// Function Definitions

void c_task_init(_task_ptr_t entrypoint, _systick_t ticks);
void c_predefined_tasks_init(void);
void c_sched_run(void);

#endif
