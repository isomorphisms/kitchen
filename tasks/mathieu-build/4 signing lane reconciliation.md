# Version 4 — registry lane reconciled before packaging

Version 4 parsed under the exact Grease entrypoint but was not executed. A fresh read found the concurrent signer registration already published in AI-CI at 5a3c7b2361e162c5743fcbb92191258bf7dc4dbe. It uses the explicit public-development lane, rather than the older generic test lane. Version 5 reads and verifies that application-owned lane and records it truthfully. No key or identity was changed, no competing registry row was published, and versions 3/4 did not package an APK.
