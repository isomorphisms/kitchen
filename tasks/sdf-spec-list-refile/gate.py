"""Qualification receipts bind exact operational bytes and argument intent."""
import argparse
import base64
import hashlib
import os
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def bundle(wrapper, engine):
    engine = Path(engine)
    mbox = engine.parents[2]
    paths = [Path(wrapper), HERE / "gate.py", HERE / "test_handoff.py", HERE / "requirements.md"]
    paths += [engine / name for name in ("filing.py", "framing.py", "spec_list.py")]
    paths += [mbox / "tests/hardening" / name for name in ("corpus.py", "test_filing.py", "mutations.py")]
    paths += [mbox / "CONTRACT.md", mbox / "fixtures/manifest.json"]
    paths += sorted(path for path in (mbox / "fixtures").rglob("*") if path.is_file()
                    and path != mbox / "fixtures/manifest.json")
    return [(str(path.absolute()), sha(path)) for path in paths]


def encode(text):
    return base64.b64encode(os.fsencode(text)).decode("ascii")


def content(wrapper, engine, argv):
    rows = ["format\tkitchen-mail-handoff-v1", "acceptance\tfixture-execution-only",
            "live-mutation\tBLOCKED", "interpreter\t" + encode(sys.executable) + "\t" + encode(sys.version)]
    for path, digest in bundle(wrapper, engine):
        rows.append("file\t" + encode(path) + "\t" + digest)
    for index, value in enumerate(argv):
        rows.append("argument\t" + str(index) + "\t" + encode(value))
    return "\n".join(rows) + "\n"


def verify(receipt, wrapper, engine, argv):
    expected = "tests\tPASS\n" + content(wrapper, engine, argv)
    if Path(receipt).read_text(encoding="ascii") != expected:
        raise RuntimeError("tested artifact, paths, selector, wrapper or operation intent changed")
    return expected


def qualify(receipt, wrapper, engine, argv, output):
    before = content(wrapper, engine, argv)
    # Actual fixed test suite, not an externally supplied PASS flag or test command.
    environment = dict(os.environ, KITCHEN_WRAPPER=str(wrapper), MBOX_ENGINE=str(engine))
    commands = [[sys.executable, str(HERE / "test_handoff.py")],
                [sys.executable, str(Path(engine).parents[2] / "tests/hardening/test_filing.py")],
                [sys.executable, str(Path(engine).parents[2] / "tests/hardening/mutations.py")]]
    # A quick-only environment cannot earn a normal handoff qualification.
    environment.pop("MBOX_QUICK", None)
    with open(output, "x", encoding="utf8") as stream:
        for command in commands:
            stream.write("command\t" + "\t".join(command) + "\n")
            stream.flush()
            result = subprocess.run(command, env=environment, cwd=receipt.parent,
                                    stdout=stream, stderr=subprocess.STDOUT)
            if result.returncode:
                raise RuntimeError("fixture suite failed; no handoff receipt issued")
    if content(wrapper, engine, argv) != before:
        raise RuntimeError("artifact changed during testing; no receipt issued")
    with open(receipt, "x", encoding="ascii") as stream:
        stream.write("tests\tPASS\n" + before)
    return verify(receipt, wrapper, engine, argv)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("qualify", "verify"))
    parser.add_argument("--engine", type=Path, required=True)
    parser.add_argument("--receipt", type=Path, required=True)
    parser.add_argument("--source", required=True)
    parser.add_argument("--destination", required=True)
    parser.add_argument("--mode", choices=("inspect", "copy", "move"), required=True)
    arguments = parser.parse_args()
    wrapper = HERE / "1.py"
    argv = [sys.executable, str(wrapper), "--engine", str(arguments.engine), "plan",
            "--source", arguments.source, "--destination", arguments.destination,
            "--mode", arguments.mode, "--live-spool"]
    try:
        if arguments.source != "/var/mail/isomorphisms":
            raise RuntimeError("live-spool handoff must name the exact incoming spool")
        if arguments.action == "qualify":
            result = qualify(arguments.receipt, wrapper, arguments.engine, argv,
                             Path(str(arguments.receipt) + ".execution.txt"))
        else:
            result = verify(arguments.receipt, wrapper, arguments.engine, argv)
        # This is a sealed argv record, not an untested shell wrapper.
        print(result, end="")
    except (OSError, RuntimeError) as error:
        print("REFUSED: " + str(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
