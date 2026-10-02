import unittest
from probe_reference import HELP_OUTPUT, developer_help_succeeded, hosted_native


class ReferenceProbeGuardTests(unittest.TestCase):
    def test_requires_hosted_native_environment(self):
        hosted = {'GITHUB_ACTIONS': 'true', 'RUNNER_ENVIRONMENT': 'github-hosted'}
        self.assertTrue(hosted_native(hosted, 'Darwin', 'arm64'))
        for environment, system, machine in [({}, 'Darwin', 'arm64'),
                ({'GITHUB_ACTIONS': 'true', 'RUNNER_ENVIRONMENT': 'self-hosted'}, 'Darwin', 'arm64'),
                (hosted, 'Linux', 'arm64'), (hosted, 'Darwin', 'x86_64')]:
            self.assertFalse(hosted_native(environment, system, machine))

    def test_help_requires_exact_observed_result(self):
        self.assertTrue(developer_help_succeeded(1, HELP_OUTPUT, '', False))
        for status, stdout, stderr, timeout in [
                (0, HELP_OUTPUT, '', False),
                (-6, HELP_OUTPUT, '', False),
                (1, '', 'missing Runtime_Support', False),
                (1, HELP_OUTPUT, 'unexpected error', False),
                (1, HELP_OUTPUT, '', True),
                (1, HELP_OUTPUT + 'unexpected extra output', '', False)]:
            self.assertFalse(developer_help_succeeded(status, stdout, stderr, timeout))


if __name__ == '__main__':
    unittest.main()
