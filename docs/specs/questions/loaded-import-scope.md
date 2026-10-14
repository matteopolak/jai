# Loaded import scope questions

The reviewed official control establishes plain top-level anonymous import
visibility after `#scope_file` across `#load`, while named aliases and ordinary
private constants stay private. It does not establish whether an anonymous
import inside `#if`, `#insert`, procedure bodies, local blocks or other contextual
scopes should follow the same placement rule. Their existing handling is
unchanged. Obtain independent controls before extending the rule to them.

The direct-versus-helper source-relative add-file reduction and Minimal's
`source_relative_path`/`no_cwd` behavior are a separate primary-compiler task.
Do not infer a path context or rewrite wrapper paths from this import control.
