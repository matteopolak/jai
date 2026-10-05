import contextlib
import io
import tempfile
import textwrap
import unittest
from pathlib import Path

import check_reference_resemblance as checker

# Synthetic "reference" module; every fixture here is made up for the test.
REFERENCE = """\
#import "Basic";

Widget :: struct {
    width := 10;
    height := 20;
    label: string;
}

LIMIT :: 64;
counter: int;

// Spins the flux capacitor until the gauge reads exactly nominal.
spin_capacitor :: (gauge: *Gauge, rate: float) -> bool {
    total := 0.0;
    for step: 0..gauge.steps - 1 {
        total += gauge.samples[step] * rate;
        if total > gauge.ceiling break;
    }
    gauge.reading = total / gauge.steps;
    report_reading(gauge, total);
    return gauge.reading == gauge.nominal;
}

tiny :: (a: int) -> int {
    return a * 2;
}
"""


class Fixture(unittest.TestCase):
    def setUp(self):
        scratch = tempfile.TemporaryDirectory()
        self.addCleanup(scratch.cleanup)
        self.root = Path(scratch.name)
        self.reference = self.root / "reference"
        self.stdlib = self.root / "stdlib"
        (self.reference / "modules").mkdir(parents=True)
        self.stdlib.mkdir()
        (self.reference / "modules/Gadget.jai").write_text(REFERENCE)
        self.allow = self.root / "allow.txt"
        self.allow.write_text("")

    def write(self, text, name="Gadget.jai"):
        path = self.stdlib / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(textwrap.dedent(text))

    def findings(self, checks=checker.CHECKS):
        rules = checker.load_allowlist(self.allow)
        return [message for _, _, message in checker.check(self.stdlib, self.reference, rules, checks=checks)]

    def run_main(self, *args):
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = checker.main(["--stdlib", str(self.stdlib), "--allow", str(self.allow), *args])
        return code, out.getvalue()


class Runs(Fixture):
    def test_three_copied_lines_are_reported_with_both_locations(self):
        self.write("""\
            check :: (g: *Gauge) {
                g.reading = total / g.steps;
                report_reading(g, total);
                return gauge.reading == gauge.nominal;
            }
            other :: () {
                gauge.reading = total / gauge.steps;
                report_reading(gauge, total);
                return gauge.reading == gauge.nominal;
            }
            """)
        found = self.findings(("runs",))
        self.assertEqual(len(found), 1)
        self.assertIn("stdlib/Gadget.jai:7-9: 3 consecutive lines", found[0])
        self.assertIn("reference/modules/Gadget.jai:19", found[0])

    def test_two_matching_lines_are_not_a_run(self):
        self.write("""\
            f :: () {
                report_reading(gauge, total);
                return gauge.reading == gauge.nominal;
            }
            """)
        self.assertEqual(self.findings(("runs",)), [])

    def test_declarations_imports_and_struct_fields_are_ignored(self):
        self.write("""\
            #import "Basic";
            Widget :: struct {
                width := 10;
                height := 20;
                label: string;
            }
            LIMIT :: 64;
            counter: int;
            tiny :: (a: int) -> int {
            }
            """)
        self.assertEqual(self.findings(("runs",)), [])

    def test_runs_match_whitespace_insensitively(self):
        self.write("""\
            g :: () {
                    gauge.reading   =   total / gauge.steps;
                report_reading(gauge,total);
                return gauge.reading == gauge.nominal;   // trailing comment
            }
            """)
        self.assertEqual(len(self.findings(("runs",))), 0, "token spacing inside a line still matters")
        self.write("""\
            g :: () {
                    gauge.reading   =   total / gauge.steps;
                report_reading(gauge, total);
                return gauge.reading == gauge.nominal;   // trailing comment
            }
            """)
        self.assertEqual(len(self.findings(("runs",))), 1)


class Procedures(Fixture):
    def test_renamed_locals_still_flag_a_same_named_procedure(self):
        self.write("""\
            spin_capacitor :: (gauge: *Gauge, rate: float) -> bool {
                sum := 0.0;
                for step: 0..gauge.steps - 1 {
                    sum += gauge.samples[step] * rate;
                    if sum > gauge.ceiling break;
                }
                gauge.reading = sum / gauge.steps;
                report_reading(gauge, sum);
                return gauge.reading == gauge.nominal;
            }
            """)
        found = self.findings(("procs",))
        self.assertEqual(len(found), 1)
        self.assertIn("stdlib/Gadget.jai:1: procedure 'spin_capacitor'", found[0])
        self.assertIn("reference/modules/Gadget.jai:13", found[0])

    def test_short_or_differently_named_procedures_are_skipped(self):
        self.write("""\
            tiny :: (a: int) -> int {
                return a * 2;
            }
            whirl :: (gauge: *Gauge, rate: float) -> bool {
                total := 0.0;
                for step: 0..gauge.steps - 1 {
                    total += gauge.samples[step] * rate;
                    if total > gauge.ceiling break;
                }
                gauge.reading = total / gauge.steps;
                report_reading(gauge, total);
                return gauge.reading == gauge.nominal;
            }
            """)
        self.assertEqual(self.findings(("procs",)), [])

    def test_procedures_in_other_modules_are_not_compared(self):
        self.write(REFERENCE, name="Other.jai")
        self.assertEqual(self.findings(("procs", "comments")), [])

    def test_allowlisted_procedure(self):
        self.write(REFERENCE)
        self.allow.write_text("stdlib/Gadget.jai proc:spin_capacitor only one sensible way to spin it\n")
        self.assertEqual(self.findings(("procs",)), [])


class Comments(Fixture):
    def test_reworded_comment_is_flagged_without_echoing_reference_text(self):
        self.write("""\
            // spins the flux capacitor until its gauge reads nominal
            x :: 1;
            """)
        found = self.findings(("comments",))
        self.assertEqual(len(found), 1)
        self.assertIn("stdlib/Gadget.jai:1: comment", found[0])
        self.assertIn("reference/modules/Gadget.jai:12", found[0])

    def test_independent_and_short_comments_pass(self):
        self.write("""\
            // Rotates the dial; stops at the limit.
            // flux capacitor
            x :: 1;
            """)
        self.assertEqual(self.findings(("comments",)), [])


class Allowlist(Fixture):
    def test_glob_entry_suppresses_runs_but_not_procs(self):
        self.write(REFERENCE, name="Gadget/bindings.jai")
        self.allow.write_text("stdlib/Gadget/* runs,comments C header order is the ABI\n")
        found = self.findings()
        self.assertEqual(len(found), 1)
        self.assertIn("procedure 'spin_capacitor'", found[0])

    def test_entries_need_a_reason(self):
        self.allow.write_text("stdlib/Gadget.jai runs\n")
        with self.assertRaises(SystemExit):
            checker.load_allowlist(self.allow)

    def test_unknown_check_is_rejected(self):
        self.allow.write_text("stdlib/Gadget.jai lines because\n")
        with self.assertRaises(SystemExit):
            checker.load_allowlist(self.allow)


class CommandLine(Fixture):
    def test_exit_status_and_reference_side_is_location_only(self):
        self.write(REFERENCE)
        code, out = self.run_main("--reference", str(self.reference))
        self.assertEqual(code, 1)
        self.assertIn("stdlib/Gadget.jai:", out)
        self.assertIn("reference/modules/Gadget.jai:", out)
        # Every printed line quotes only the stdlib side (the comment we wrote is in stdlib too).
        self.assertNotIn("for step:", out)

    def test_clean_tree_exits_zero(self):
        self.write("""\
            add :: (a: int, b: int) -> int {
                return a + b;
            }
            """)
        code, out = self.run_main("--reference", str(self.reference))
        self.assertEqual((code, "no resemblance found" in out), (0, True))

    def test_missing_reference_is_skipped(self):
        code, out = self.run_main("--reference", str(self.root / "absent"))
        self.assertEqual(code, 0)
        self.assertIn("skipping", out)

if __name__ == "__main__":
    unittest.main()
