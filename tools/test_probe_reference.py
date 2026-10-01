import unittest
from probe_reference import hosted_native


class ReferenceProbeGuardTests(unittest.TestCase):
    def test_requires_hosted_native_environment(self):
        hosted = {'GITHUB_ACTIONS': 'true', 'RUNNER_ENVIRONMENT': 'github-hosted'}
        self.assertTrue(hosted_native(hosted, 'Darwin', 'arm64'))
        for environment, system, machine in [({}, 'Darwin', 'arm64'),
                ({'GITHUB_ACTIONS': 'true', 'RUNNER_ENVIRONMENT': 'self-hosted'}, 'Darwin', 'arm64'),
                (hosted, 'Linux', 'arm64'), (hosted, 'Darwin', 'x86_64')]:
            self.assertFalse(hosted_native(environment, system, machine))


if __name__ == '__main__':
    unittest.main()
