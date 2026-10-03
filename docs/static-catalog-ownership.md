# Static catalog ownership

## What it is

Checked immutable storage catalogs carry sealed retained-byte and validation-work receipts. A consumer uses one actual table/object union allowance before retaining RuntimeType catalog references.

## How it works

The builder measures moved StringBytes and aggregate capacities, boxed values, projection paths, ByteViews, descriptor layouts/names/notes/members, actual object Arc headers, and each immutable catalog table. Object and cumulative publication admission happen before retention; failed unpublished construction remains disposable. Publication runs the actual validator through a measured TypeView and seals its work bound. Validation work and retained ownership remain separate.

`StaticCatalogBudget` deduplicates exact Weak table identities and genuine StaticObject IDs. A cloned table owns another table allocation while sharing object payloads. Weak receipts retain no payload history. Every comparison is charged, every duplicate hit checks the current allowance, and replacement receipt backing is admitted while old backing coexists. Typed shared coverage certifies actual facts before payload credit; fresh refresh keeps departing payload reserved until the owner swap.

## How to change it

Add every new constant, descriptor, or projection payload to retained-byte and validation-work producers. Update the closed union consumer at the same time. Future Slice/OwnedStorage variants require their full backing/source receipts; this foundational packet does not add those variants. VM and source owner adoption must scan their real live roots under one allowance; merely registering this helper does not establish that lifecycle.

## Configuration

`StaticDataLimits.retained_bytes` defaults to 64 MiB and includes actual spare payload capacity. The builder's cumulative publication cap also uses that default. Consumers supply their real remaining retained-byte allowance; the VM uses the existing conservative one-byte-per-ValueCell convention. Inspection work consumes its own caller meter.

## Dependencies

IR StaticData/RuntimeTypeBinding, jai-types TypeView/descriptor/layout receipts, and the consumer's actual root ownership and work meter. The recovery packet is private, formatted and apply-checked only; its three new regressions are authored but unrun.
