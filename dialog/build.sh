#!/bin/bash
# Build the CommitDialog binary. Run after editing main.swift.
# Output: .build/release/CommitDialog
set -e
cd "$(dirname "$0")"
swift build -c release
echo "Built: $(pwd)/.build/release/CommitDialog"
