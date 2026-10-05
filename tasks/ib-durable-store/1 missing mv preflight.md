# Version 1: omitted mv from the dependency preflight

During October 4 host fixture validation, version 1 passed 17 cases but review
found that the existing IB baseline also invokes `mv`. Version 2 adds that
command to the explicit dependency check before any test executes. The original
candidate is preserved rather than silently rewriting tested evidence.

No physical-phone run of either wrapper is claimed. The phone result supplied
by the human was the older direct IB baseline, not this wrapper.
