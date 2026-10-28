# Deadlock Detection and Recovery System

OS project simulation (Python 3, standard library only).

- Processes request shared resources (printer, file, memory, disk) with multiple instances.
- Builds a resource-allocation graph (`--dot out.dot`, render with `dot -Tpng out.dot -o rag.png`).
- Detects circular waits (wait-for graph cycle) and deadlocks (multi-instance detection algorithm).
- Compares recovery: terminate all, terminate one-by-one (cheapest victim), resource preemption with rollback + starvation guard.

```
python3 deadlock.py                      # classic 3-process circular wait
python3 deadlock.py --scenario random --processes 6 --seed 3
python3 -m unittest discover -s tests
```

Concepts: deadlocks, resource allocation, process termination, preemption.
