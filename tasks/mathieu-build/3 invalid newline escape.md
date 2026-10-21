# Version 3 — recipe format rejected before execution

On 2026-10-21 the exact Grease parser rejected the double-quoted printf format's newline escape (OILS-ERR-12). No package or signing action ran. Version 4 retains the same contract but writes Ike recipes with the already established expanding heredoc form used by versions 1 and 2. Version 3 is preserved as failed parser evidence and is not a runnable packaging entrypoint.
