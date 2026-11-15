# Grease syntax check rejected version 1

2026-10-19, Linux x86_64. The actual compiled Grease runtime rejected the
double-quoted printf format containing backslash-n (OILS-ERR-12). No compilation
or parser test ran through version 1. Version 2 uses a heredoc for the Ikefile.
Regression: run the actual Grease syntax check before attempting any phase.
