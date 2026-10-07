"""Versioned operational artifact. Live operations are read-only plans only."""
import argparse
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True)
    sub = parser.add_subparsers(dest="command", required=True)
    plan = sub.add_parser("plan")
    plan.add_argument("--source", required=True)
    plan.add_argument("--destination", required=True)
    plan.add_argument("--mode", choices=("inspect", "copy", "move"), required=True)
    plan.add_argument("--live-spool", action="store_true")
    execute = sub.add_parser("execute-disposable")
    execute.add_argument("--plan", required=True)
    execute.add_argument("--disposable-root", required=True)
    arguments = parser.parse_args()
    engine = Path(arguments.engine)
    if not engine.is_absolute() or not (engine / "filing.py").is_file():
        parser.error("absolute verified executor directory required")
    if arguments.command == "plan":
        child = ["plan", "--source", arguments.source, "--destination", arguments.destination,
                 "--mode", arguments.mode]
        if arguments.live_spool:
            child += ["--live-spool", "/var/mail/isomorphisms"]
    else:
        child = ["execute-disposable", "--plan", arguments.plan,
                 "--disposable-root", arguments.disposable_root]
    return subprocess.run([sys.executable, str(engine / "filing.py")] + child).returncode


if __name__ == "__main__":
    sys.exit(main())
