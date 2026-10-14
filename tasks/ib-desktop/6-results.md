# Attempt 6 — compiler Unicode-path failure

The actual Grease source-file recipe correctly preserved spaces, apostrophes and
Unicode. The C boundary compiled through ICK. Maintained Idriç 94dfd99bd then
generated compileChez with `\26481\20140` for 東京. Chez interpreted those as
octal escapes followed by digits and could not find the generated source. The
compiler printed Error: INTERNAL ERROR but returned zero; test -x correctly
refused the missing executable. This executed failure is retained in FP.

Compiler/Scheme/Chez.idr at 94dfd99bd builds the compile-program operand with
show outSsAbs instead of its existing Scheme-specific escaping. This is a real
upstream compiler gap, not an IB Unicode-text or Grease-quoting failure.

Attempt 8 declares an ASCII build-root restriction and refuses non-ASCII roots
explicitly before effects. It also rejects Error: compiler output, hashes every
imported IB module, and tests relocation/launch into a Unicode/apostrophe path.
The compiler restriction remains open until its upstream job is accepted.
