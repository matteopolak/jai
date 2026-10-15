#!/usr/bin/env python3
"""Select the reviewed raw heap source profile in an OWNED/staged stdlib tree.

This private build setting supplies a genuinely undeclared compile-time option.
It is not a new public Jai module parameter or a reference-default claim.
"""
import argparse
from pathlib import Path


def configure(stdlib, enabled):
    if not (stdlib/'rpmalloc/module.jai').is_file():
        raise ValueError('Expected a stdlib tree containing the public rpmalloc facade')
    target = stdlib/'internal/bindings/rpmalloc-build/module.jai'
    if not target.is_file():
        raise ValueError('The independent rpmalloc build configuration is missing')
    target.write_text('// Explicit private packaging selection; no public import parameter.\n'
                      'FIRST_CLASS_HEAPS :: '+('true' if enabled else 'false')+';\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--stdlib', type=Path, required=True)
    parser.add_argument('--first-class-heaps', choices=('true', 'false'), required=True)
    args = parser.parse_args()
    configure(args.stdlib, args.first_class_heaps == 'true')
