# Original signed source rejected by the pinned compiler

The requirement was to execute the existing signed source unchanged, not translate its notation to make a different program pass. At Dirichlet base `9458368792003be88a9499db676279b359e5ddf9`, `idric/GeometricFinite.idric` has SHA-256 `2595b69fca1d8990a6ffe0a4c352b7296db77e591de9280bbe05240c6955da82`.

The real pinned Idriç compiler printed `Undefined name ±Number` and `Undefined name −`. No fresh matching TTC was accepted. FP and Ike retain failure, including the raw compiler output and exact input hashes. This is a compiler/library capability gap, not a proof of false mathematics.

Candidate 2 provides a separate per-module route, preserving this attempt. Its natural-number source and false-witness source each have distinct bytes, output directories and evidence scopes. It must not relabel the signed source as accepted.
