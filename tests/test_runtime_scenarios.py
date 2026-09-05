from __future__ import annotations

import csv
import json
from pathlib import Path
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import runtime_scenarios


def scenario_document() -> dict[str, object]:
    return {
        "schema_version": 1,
        "rom_sha1": "0" * 40,
        "scenarios": [
            {
                "id": "boot",
                "method": "test",
                "max_frames": 10,
                "inputs": [
                    {"start_frame": 2, "end_frame": 3, "buttons": ["start"]}
                ],
                "expected_events": {"first_nmi": 1},
                "expected_event_details": {"first_nmi": "NMI"},
                "expected_final": {"frame": "10", "thread": "01"},
            }
        ],
    }


def trace_rows() -> list[dict[str, str]]:
    return [
        {
            "frame": "0",
            "event": "trace_start",
            "detail": "boot",
            "thread": "00",
            "room": "00",
            "timer": "00000000",
            "dana_y": "00",
            "dana_x": "00",
            "active_enemies": "00",
        },
        {
            "frame": "1",
            "event": "first_nmi",
            "detail": "NMI",
            "thread": "00",
            "room": "00",
            "timer": "00000000",
            "dana_y": "00",
            "dana_x": "00",
            "active_enemies": "00",
        },
        {
            "frame": "10",
            "event": "trace_end",
            "detail": "boot",
            "thread": "01",
            "room": "00",
            "timer": "00000000",
            "dana_y": "00",
            "dana_x": "00",
            "active_enemies": "00",
        },
    ]


class ScenarioTests(unittest.TestCase):
    def test_loads_and_encodes_inputs(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "scenarios.json"
            path.write_text(json.dumps(scenario_document()))
            document = runtime_scenarios.load_scenarios(path)
            scenario = document["scenarios"][0]
            self.assertEqual(runtime_scenarios.encode_inputs(scenario), "2-3:start")

    def test_rejects_overlapping_inputs(self) -> None:
        scenario = scenario_document()["scenarios"][0]
        scenario["inputs"].append(
            {"start_frame": 3, "end_frame": 4, "buttons": ["a"]}
        )
        with self.assertRaisesRegex(runtime_scenarios.RuntimeError, "overlapping"):
            runtime_scenarios.validate_inputs(scenario)

    def test_rejects_unknown_button(self) -> None:
        scenario = scenario_document()["scenarios"][0]
        scenario["inputs"][0]["buttons"] = ["turbo"]
        with self.assertRaisesRegex(runtime_scenarios.RuntimeError, "buttons"):
            runtime_scenarios.validate_inputs(scenario)


class TraceTests(unittest.TestCase):
    def test_validates_expected_event_and_final_state(self) -> None:
        scenario = scenario_document()["scenarios"][0]
        runtime_scenarios.validate_trace(scenario, trace_rows())

    def test_detects_changed_event_frame(self) -> None:
        scenario = scenario_document()["scenarios"][0]
        rows = trace_rows()
        rows[1]["frame"] = "2"
        with self.assertRaisesRegex(runtime_scenarios.RuntimeError, "first_nmi"):
            runtime_scenarios.validate_trace(scenario, rows)

    def test_detects_changed_event_detail(self) -> None:
        scenario = scenario_document()["scenarios"][0]
        rows = trace_rows()
        rows[1]["detail"] = "wrong"
        with self.assertRaisesRegex(runtime_scenarios.RuntimeError, "detail"):
            runtime_scenarios.validate_trace(scenario, rows)

    def test_detects_forbidden_event(self) -> None:
        scenario = scenario_document()["scenarios"][0]
        scenario["forbidden_events"] = ["first_nmi"]
        with self.assertRaisesRegex(runtime_scenarios.RuntimeError, "forbidden"):
            runtime_scenarios.validate_trace(scenario, trace_rows())

    def test_load_trace_checks_schema_and_monotonic_frames(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "trace.csv"
            rows = trace_rows()
            rows[1]["frame"] = "11"
            with path.open("w", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=rows[0].keys())
                writer.writeheader()
                writer.writerows(rows)
            with self.assertRaisesRegex(runtime_scenarios.RuntimeError, "monotonic"):
                runtime_scenarios.load_trace(path)


if __name__ == "__main__":
    unittest.main()
