#!/usr/bin/env bash
#
# Fetch upstream dataset sources into contrib/epistemic/bench/datasets/*/source/.
#
# The normalized JSONL fixtures cited by the paper are already committed in this
# repo (contrib/epistemic/bench/datasets/*/normalized*.jsonl). This script is
# only needed if you want to re-run the normalization step from raw upstream
# data (see normalize.py).
#
# Datasets:
#   - Book-Author  (Dong et al., VLDB 2009): https://lunadong.com/fusionDataSets.htm
#   - LongMemEval:  https://github.com/xiaowu0162/LongMemEval
#   - MQuAKE:       https://github.com/princeton-nlp/MQuAKE
#   - MemoryAgentBench: https://github.com/HUST-AI-HYZ/MemoryAgentBench
#   - Zheng sentiment: institutional source; see zheng_sentiment/README.md
#
# Usage:
#   ./bootstrap.sh [dataset]      # dataset = one of the names above; omit for all

set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

fetch_longmemeval() {
  local d="$here/longmemeval/source"
  [ -d "$d" ] && { echo "longmemeval/source exists, skipping"; return; }
  mkdir -p "$d" && git clone --depth 1 https://github.com/xiaowu0162/LongMemEval "$d/LongMemEval"
}

fetch_mquake() {
  local d="$here/mquake/source"
  [ -d "$d" ] && { echo "mquake/source exists, skipping"; return; }
  mkdir -p "$d" && git clone --depth 1 https://github.com/princeton-nlp/MQuAKE "$d/MQuAKE"
}

fetch_memoryagentbench() {
  local d="$here/memoryagentbench/source"
  [ -d "$d" ] && { echo "memoryagentbench/source exists, skipping"; return; }
  mkdir -p "$d" && git clone --depth 1 https://github.com/HUST-AI-HYZ/MemoryAgentBench "$d/MemoryAgentBench"
}

fetch_bookauthor() {
  local d="$here/bookauthor/source"
  [ -d "$d" ] && { echo "bookauthor/source exists, skipping"; return; }
  mkdir -p "$d"
  echo "bookauthor: fetch book.zip manually from https://lunadong.com/fusionDataSets.htm into $d/"
}

target="${1:-all}"
case "$target" in
  longmemeval)       fetch_longmemeval ;;
  mquake)            fetch_mquake ;;
  memoryagentbench)  fetch_memoryagentbench ;;
  bookauthor)        fetch_bookauthor ;;
  all)
    fetch_longmemeval
    fetch_mquake
    fetch_memoryagentbench
    fetch_bookauthor
    ;;
  *)
    echo "unknown dataset: $target" >&2
    exit 1
    ;;
esac
