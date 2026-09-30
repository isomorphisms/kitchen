# Prerequisite failure followed by more mutations

## Failure

The instructions assumed a package existed, then assumed exported files existed,
then changed their permissions and contents, then tried to execute them.

When the first assumption failed, later commands produced a cascade of
irrelevant errors instead of stopping at the missing prerequisite.

## Regression

Represent these states separately:

- package unavailable;
- package installed but export absent;
- export present at a different observed path;
- executable unavailable on PATH;
- service unavailable or unauthorized;
- successful launch.

The first failed prerequisite must stop the recipe before later mutations.

Related: Kitchen issue #5.
