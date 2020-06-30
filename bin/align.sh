#!/bin/bash
approot=$(cd "$(dirname "$(dirname "$0")")" && pwd)
. "$approot/venv/bin/activate"
python "$approot/align/align.py" "$@"
