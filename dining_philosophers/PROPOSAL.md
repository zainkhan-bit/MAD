# Project Proposal

## Dining Philosophers: Deadlock and Synchronization Simulator

**Course:** Operating Systems
**Student:** ____________________  **Reg. No.:** ____________
**Instructor:** ____________________  **Date:** ____________

---

## 1. Introduction

The Dining Philosophers problem is a classic synchronization problem in Operating Systems. Five philosophers sit around a table with five forks, one between each pair. A philosopher alternates between thinking, becoming hungry, and eating, and needs both the left and right fork to eat. If every philosopher picks up the left fork at the same time, each waits forever for the right one: a **deadlock** caused by circular wait.

This project builds an interactive, animated simulator that shows the deadlock happening and then demonstrates how different solutions prevent it.

## 2. Objectives

- Simulate five concurrent philosophers sharing five forks.
- Visually demonstrate deadlock and starvation.
- Implement and compare deadlock-free solutions.
- Show how the four deadlock conditions (mutual exclusion, hold and wait, no preemption, circular wait) apply.

## 3. Scope and Features

| Feature | Description |
|---|---|
| Animated table | Circular table with 5 philosophers and 5 forks. |
| State colours | Blue = thinking, yellow = hungry, green = eating, red = deadlocked. |
| Naive mode | Every philosopher takes the left fork first, so deadlock occurs. |
| Fix 1: Resource ordering | Forks are numbered; the lower number is always taken first (breaks circular wait). |
| Fix 2: Waiter | At most 4 philosophers may try to eat at once. |
| Fix 3: Semaphores/mutex | Forks protected by locks with atomic pick-up of both forks. |
| Controls | Start, pause, reset, speed slider, strategy selector. |
| Live log | Events such as "P2 picked fork 2". |
| Statistics | Meals eaten per philosopher, waiting time, deadlock count, and a fairness/starvation indicator. |

## 4. Operating System Concepts Covered

Deadlocks, circular wait, resource allocation, synchronization, mutex and semaphores, concurrency, starvation, and deadlock prevention.

## 5. Methodology

1. Model each philosopher as a concurrent process/thread with the cycle think -> hungry -> eat.
2. Model forks as shared resources protected by locks.
3. Detect deadlock when all philosophers are waiting and none can proceed (wait-for cycle detection).
4. Implement each solution strategy as a plug-in so they can be switched and compared.
5. Render the simulation with an HTML5 canvas animation and display statistics.

## 6. Tools and Technologies

- HTML, CSS, JavaScript (HTML5 Canvas), runs in any browser with nothing to install.
- Git/GitHub for version control.

## 7. Expected Output

A working browser-based simulator where the user can watch the deadlock occur, switch to each fix, and compare results through the statistics panel.

## 8. Timeline

| Week | Task |
|---|---|
| 1 | Study the problem and design the simulation model |
| 2 | Implement philosophers, forks and the naive (deadlock) mode |
| 3 | Add deadlock detection and the three solutions |
| 4 | Build the animated GUI, controls, log and statistics |
| 5 | Testing, report and presentation |

## 9. Conclusion

The project makes an abstract OS topic visible. Watching the circular wait turn the table red, and then seeing it resolved, helps explain why deadlocks occur and how operating systems avoid them.
