# Unsupported descriptor test premises

The refreshed Socket descriptor-set contract requires a non-null initialized
set. Unix negative descriptors are outside the supported domain. These legacy
expectations therefore cannot be used as compatibility requirements:

```jai
FD_SET(-1, *set); // Former expectation: ignored.
assert(FD_ISSET(-1, *set) == 0);
assert(FD_ISSET(3, null) == 0);
FD_SET(3, null); // Former expectation: ignored.
FD_CLR(3, null); // Former expectation: ignored.
```

They were removed from the active comprehensive loopback fixture after contract
review. No production null/negative no-op behavior was added. The existing Unix
mutation assertion for a negative descriptor remains an independent safety
policy, not a promise about unsupported inputs.

The supported Unix cases are retained and strengthened: descriptor capacity and
capacity+1000 are ignored by SET/CLR and report zero membership; valid last-bit
and word-boundary behavior remain required. A focused fixture also fills every
valid bit, clears odd bits, retains a nonempty set while checking capacity,
capacity+1 and s32 maximum, and verifies neighboring sentinel storage.

That fixture first failed against the prior implementation at FD_SET(capacity):
the old unconditional assertion incorrectly rejected a reviewed supported case.
The production correction checks the high bound before the remaining assertion.
This is separate from removing unsupported legacy test premises.

Windows uses counted opaque SOCKET values. Its new pure #run fixture checks zero,
all-ones, high-bit and ordinary values, duplicates, full capacity, absent removal,
compaction and refill. It does not call native Winsock membership on a non-Windows
host or pretend the Unix numeric descriptor limit applies to Windows.

Original producer failure evidence is retained in the assigned T7 directories:

- asn1-socket-w1se6nb6/fixture-12-interp.stderr and fixture-12-O0/O2-native outputs:
  unsupported legacy FD_SET(-1) failure in interpreter and actual native modes.
- descriptor-red-w9mh2krm/stderr: independent supported FD_SET(capacity) failure
  before the general high-descriptor guard was added.

No original/reference evidence was consulted. There is still no public FD_ZERO;
tests zero-initialize the public fd_set record.

## Other legacy native-helper assumptions found during reconciliation

The comprehensive fixture next demanded CMSG_FIRSTHDR(null)==null. Ancillary
helpers require a live msghdr record; a null msg_control field inside that live
record is supported and still tested. The null-record expectation was removed,
without changing production CMSG_FIRSTHDR. The prior failing run is retained at
asn1-socket-6u1yrxfl/fixture-13-interp.stderr and both native outputs.

It then demanded set_keepalive(client,true,-1)==false, followed by an assertion
that keepalive remained off. Negative timing rejection is not established by
the reviewed helper contract. Furthermore, the reviewed operation explicitly
states that false can follow a partial configuration change. The unsupported
negative call was removed; positive/default timing and enable/disable cases and
the actual disabled-state getsockopt assertion remain. Production keepalive
behavior was not changed to satisfy an unsupported rejection/rollback premise.
The independent interpreter failure is retained under
asn1-socket-6u1yrxfl/legacy-domain-audit-6wf1bfw2.

Negative timing behavior remains a fine specification question rather than an
invented false/no-op/rollback guarantee. These corrections do not alter the
required descriptor coverage or suppress any supported native operation checks.
