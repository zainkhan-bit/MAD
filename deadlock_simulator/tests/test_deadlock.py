import copy
import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import deadlock as d


class DeadlockTests(unittest.TestCase):
    def test_classic_detects_circular_wait(self):
        s = d.classic_scenario()
        dead, _ = d.detect(s)
        self.assertEqual(dead, ["P1", "P2", "P3"])
        self.assertIsNotNone(s.find_cycle())

    def test_no_deadlock_when_resource_free(self):
        s = d.classic_scenario()
        s.request["P3"] = {}
        self.assertEqual(d.detect(s)[0], [])
        self.assertIsNone(s.find_cycle())

    def test_every_strategy_resolves(self):
        for name, fn in d.STRATEGIES.items():
            s = d.classic_scenario()
            fn(s)
            self.assertEqual(d.detect(s)[0], [], name)

    def test_one_by_one_kills_cheapest(self):
        s = d.classic_scenario()
        log, kills, cost = d.recover_terminate_one_by_one(s)
        self.assertEqual((kills, cost), (1, 2))  # only P2 (cost 2) needed
        self.assertIn("P2", log[0])

    def test_random_scenarios_resolve(self):
        for seed in range(50):
            base = d.random_scenario(6, seed)
            for fn in d.STRATEGIES.values():
                s = copy.deepcopy(base)
                fn(s)
                self.assertEqual(d.detect(s)[0], [])


if __name__ == "__main__":
    unittest.main()
