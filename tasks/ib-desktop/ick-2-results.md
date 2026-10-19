# ICK producer wrapper attempt 2

The single-digit validator used a pipeline in a command conditional. Native
Grease correctly refused that ambiguous status boundary (OILS-ERR-300), before
the build began. The FP failure is retained. ick-3.grease instead uses explicit
text comparisons for the eight permitted worker bounds, keeping one condition
and the same native producer inputs.
