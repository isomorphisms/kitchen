# Cat Food provenance

Cat Food is the upstream source for durable device identity, Android delivery,
and observed phone/tablet storage facts.

Kitchen should use those facts while preparing commands, but keep their scope
and dates intact. In particular, do not generalize:

- phone paths to tablet;
- tablet limitations to phone;
- Termux permissions to adb/rish/root;
- a previously observed removable mount into a guaranteed present mount;
- a shared-storage path into an executable path.

Relevant upstream starting point:
https://github.com/isomorphisms/catfood/blob/main/AGENTS.md
