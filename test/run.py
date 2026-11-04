"""Run table/scroll regressions; optionally include a real document and init.lua."""
import argparse
from pathlib import Path
import subprocess
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--document", type=Path)
parser.add_argument("--user-config", type=Path)
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
if args.user_config and not args.document:
    parser.error("--user-config requires --document")

commands = [["nvim", "--headless", "-u", "NONE", "-l", "test/wrapped_tables.lua"]]
for script in ("table_rows", "review_lifecycle", "splitview_align", "splitview_mouse"):
    commands.append([sys.executable, f"test/{script}.py"])
if args.document:
    document = str(args.document.resolve())
    commands.append([sys.executable, "test/single_window_scroll.py", document])
    if args.user_config:
        commands.append([sys.executable, "test/single_window_scroll.py", document, "--user-config", str(args.user_config.resolve())])
    commands.append([sys.executable, "test/report_scroll.py", document])
for command in commands:
    print("Running", " ".join(command), flush=True)
    subprocess.run(command, cwd=root, check=True)
print(f"All {len(commands)} regression suites passed", flush=True)
