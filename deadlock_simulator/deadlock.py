"""Deadlock Detection and Recovery System (OS project simulation).

Simulates processes requesting shared resources (printers, files, memory),
builds a resource-allocation graph, detects deadlocks, and compares
recovery strategies (process termination vs. resource preemption).
Standard library only.
"""
import argparse
import copy
import random
from dataclasses import dataclass, field


@dataclass
class System:
    # resource name -> total instances
    resources: dict
    # process name -> {resource: instances held}
    allocation: dict = field(default_factory=dict)
    # process name -> {resource: instances requested and waiting}
    request: dict = field(default_factory=dict)
    # process name -> cost of killing / rolling back (priority, work done)
    cost: dict = field(default_factory=dict)

    @property
    def processes(self):
        return sorted(self.allocation)

    def held(self, r):
        return sum(a.get(r, 0) for a in self.allocation.values())

    def available(self):
        return {r: n - self.held(r) for r, n in self.resources.items()}

    def validate(self):
        for r, n in self.resources.items():
            if self.held(r) > n:
                raise ValueError(f"over-allocated resource {r}")
        for p, req in self.request.items():
            for r, n in req.items():
                if r not in self.resources or n > self.resources[r]:
                    raise ValueError(f"{p} requests more {r} than exists")

    # ---- resource-allocation graph --------------------------------------
    def rag_edges(self):
        """Edges: ('P','R') = request edge, ('R','P') = assignment edge."""
        edges = []
        for p in self.processes:
            for r, n in self.request.get(p, {}).items():
                if n:
                    edges.append((p, r, "request", n))
            for r, n in self.allocation[p].items():
                if n:
                    edges.append((r, p, "assign", n))
        return edges

    def to_dot(self, deadlocked=()):
        lines = ["digraph RAG {", "  rankdir=LR;"]
        for p in self.processes:
            color = "red" if p in deadlocked else "lightblue"
            lines.append(f'  {p} [shape=circle, style=filled, fillcolor={color}];')
        for r, n in self.resources.items():
            lines.append(f'  {r} [shape=box, label="{r} ({n})"];')
        for a, b, kind, n in self.rag_edges():
            style = "dashed" if kind == "request" else "solid"
            lines.append(f'  {a} -> {b} [style={style}, label="{n}"];')
        lines.append("}")
        return "\n".join(lines)

    def find_cycle(self):
        """Cycle in the wait-for graph (exact for single-instance resources)."""
        waits = {p: set() for p in self.processes}
        for p, req in self.request.items():
            for r, n in req.items():
                if n:
                    for q in self.processes:
                        if q != p and self.allocation[q].get(r, 0):
                            waits[p].add(q)
        state, stack = {}, []

        def dfs(u):
            state[u] = 1
            stack.append(u)
            for v in sorted(waits[u]):
                if state.get(v) == 1:
                    return stack[stack.index(v):] + [v]
                if v not in state:
                    c = dfs(v)
                    if c:
                        return c
            stack.pop()
            state[u] = 2

        for p in self.processes:
            if p not in state:
                c = dfs(p)
                if c:
                    return c
        return None


def detect(system):
    """Deadlock detection algorithm (multi-instance, banker's style).

    Returns the list of deadlocked processes (empty if none) and the
    order in which the others could finish.
    """
    work = system.available()
    finish = {p: not any(system.allocation[p].values()) for p in system.processes}
    order = [p for p, f in finish.items() if f]
    progress = True
    while progress:
        progress = False
        for p in system.processes:
            if finish[p]:
                continue
            need = system.request.get(p, {})
            if all(need.get(r, 0) <= work[r] for r in work):
                for r, n in system.allocation[p].items():
                    work[r] += n
                finish[p] = True
                order.append(p)
                progress = True
    return [p for p in system.processes if not finish[p]], order


# ---- recovery strategies -------------------------------------------------
def _release(system, p):
    system.allocation[p] = {}
    system.request[p] = {}


def _grant_pending(system):
    """Hand freed resources to waiting processes whose request now fits."""
    avail = system.available()
    for p in system.processes:
        req = system.request.get(p, {})
        if req and all(n <= avail[r] for r, n in req.items()):
            for r, n in req.items():
                system.allocation[p][r] = system.allocation[p].get(r, 0) + n
                avail[r] -= n
            system.request[p] = {}


def recover_terminate_all(system):
    log, dead = [], detect(system)[0]
    for p in dead:
        log.append(f"terminate {p}")
        _release(system, p)
    _grant_pending(system)
    return log, len(dead), sum(system.cost.get(p, 1) for p in dead)


def recover_terminate_one_by_one(system):
    """Kill the cheapest deadlocked process, re-run detection, repeat."""
    log, kills, total = [], 0, 0
    while True:
        dead = detect(system)[0]
        if not dead:
            break
        victim = min(dead, key=lambda p: (system.cost.get(p, 1), p))
        log.append(f"terminate {victim} (cost {system.cost.get(victim, 1)})")
        total += system.cost.get(victim, 1)
        kills += 1
        _release(system, victim)
        _grant_pending(system)
    return log, kills, total


def recover_preempt(system, max_rollbacks=3):
    """Preempt resources from the cheapest victim and roll it back.

    The victim loses what it holds but stays alive and re-requests it
    later. A rollback counter prevents starvation: after max_rollbacks
    the victim is terminated instead.
    """
    log, ops, total = [], 0, 0
    rollbacks = {}
    while True:
        dead = detect(system)[0]
        if not dead:
            break
        victim = min(
            dead,
            key=lambda p: (rollbacks.get(p, 0), system.cost.get(p, 1), p),
        )
        cost = system.cost.get(victim, 1)
        total += cost
        ops += 1
        rollbacks[victim] = rollbacks.get(victim, 0) + 1
        held = {r: n for r, n in system.allocation[victim].items() if n}
        if rollbacks[victim] > max_rollbacks:
            log.append(f"terminate {victim} (starvation guard)")
            _release(system, victim)
        else:
            log.append(f"preempt {held} from {victim}; rollback to safe state")
            system.allocation[victim] = {}
            # victim re-requests everything it lost plus what it wanted,
            # but after the others have had their turn
            _grant_pending(system)
            if system.request.get(victim) is not None:
                for r, n in held.items():
                    system.request[victim][r] = system.request[victim].get(r, 0) + n
            # let the others finish first (simulated): if nobody else can
            # run, the victim is waiting alone and the system is unblocked
            _finish_runnable(system, exclude=victim)
            _grant_pending(system)
            if any(system.request.get(victim, {}).values()):
                continue
        _grant_pending(system)
    return log, ops, total


def _finish_runnable(system, exclude=None):
    """Run processes that are not blocked to completion and free their resources."""
    changed = True
    while changed:
        changed = False
        for p in system.processes:
            if p == exclude:
                continue
            if system.allocation[p] and not any(system.request.get(p, {}).values()):
                _release(system, p)
                _grant_pending(system)
                changed = True


STRATEGIES = {
    "terminate-all": recover_terminate_all,
    "terminate-one-by-one": recover_terminate_one_by_one,
    "preempt": recover_preempt,
}


# ---- scenarios -----------------------------------------------------------
def classic_scenario():
    """P1 holds printer & wants file; P2 holds file & wants memory;
    P3 holds memory & wants printer (circular wait); P4 is innocent."""
    s = System(resources={"printer": 1, "file": 1, "memory": 1, "disk": 2})
    s.allocation = {
        "P1": {"printer": 1},
        "P2": {"file": 1},
        "P3": {"memory": 1},
        "P4": {"disk": 1},
    }
    s.request = {"P1": {"file": 1}, "P2": {"memory": 1}, "P3": {"printer": 1}, "P4": {}}
    s.cost = {"P1": 5, "P2": 2, "P3": 8, "P4": 1}
    return s


def random_scenario(n_proc, seed):
    rng = random.Random(seed)
    s = System(resources={"printer": 2, "file": 3, "memory": 4})
    avail = dict(s.resources)
    for i in range(1, n_proc + 1):
        p = f"P{i}"
        s.allocation[p], s.request[p] = {}, {}
        s.cost[p] = rng.randint(1, 10)
        for r in s.resources:
            k = rng.randint(0, min(1, avail[r]))
            if k:
                s.allocation[p][r] = k
                avail[r] -= k
    for p in s.processes:
        r = rng.choice(list(s.resources))
        s.request[p][r] = rng.randint(1, s.resources[r])
    s.validate()
    return s


def report(system, title):
    print(f"\n=== {title} ===")
    print("available:", system.available())
    for p in system.processes:
        print(f"  {p}: holds {system.allocation[p] or '-'}  waits {system.request.get(p) or '-'}")
    dead, order = detect(system)
    cyc = system.find_cycle()
    print("wait-for cycle:", " -> ".join(cyc) if cyc else "none")
    print("deadlocked:", dead or "none (safe finish order: %s)" % order)
    return dead


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--scenario", choices=["classic", "random"], default="classic")
    ap.add_argument("--processes", type=int, default=6)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--dot", help="write resource-allocation graph (Graphviz) to file")
    args = ap.parse_args(argv)

    system = classic_scenario() if args.scenario == "classic" else random_scenario(args.processes, args.seed)
    dead = report(system, "Initial state")
    if args.dot:
        with open(args.dot, "w") as f:
            f.write(system.to_dot(dead))
        print(f"graph written to {args.dot}")
    if not dead:
        print("\nNo deadlock - nothing to recover.")
        return

    print("\n=== Recovery strategy comparison ===")
    print(f"{'strategy':<22}{'actions':>8}{'cost':>6}  steps")
    for name, fn in STRATEGIES.items():
        trial = copy.deepcopy(system)
        log, n, cost = fn(trial)
        ok = "resolved" if not detect(trial)[0] else "STILL DEADLOCKED"
        print(f"{name:<22}{n:>8}{cost:>6}  {ok}")
        for line in log:
            print(f"    - {line}")


if __name__ == "__main__":
    main()
