#!/bin/bash
# Error-path tests for the CommitDialog CLI.
# Asserts the binary exits 2 on bad input.

set -u

BINARY="$(dirname "$0")/.build/release/CommitDialog"
[ -x "$BINARY" ] || { echo "Build first: swift build -c release"; exit 1; }

PASS=0
FAIL=0

check() {
    local label="$1"
    local expected="$2"
    local actual="$3"
    if [ "$actual" = "$expected" ]; then
        echo "  PASS  $label"
        PASS=$((PASS + 1))
    else
        echo "  FAIL  $label (expected exit $expected, got $actual)"
        FAIL=$((FAIL + 1))
    fi
}

echo "==> CLI error-path tests"

# Test 1: malformed JSON on stdin -> exit 2
echo '{not-valid-json' | "$BINARY" >/dev/null 2>&1
check "exits 2 on malformed stdin" 2 "$?"

# Test 2: missing argv file -> exit 2
"$BINARY" /tmp/no-such-file-commit-craft-12345.json >/dev/null 2>&1
check "exits 2 on missing argv file" 2 "$?"

# Test 3: argv file with malformed JSON -> exit 2 (file-read code path, distinct from stdin)
TMP="$(mktemp)"
echo '{also-not-valid-json' > "$TMP"
"$BINARY" "$TMP" >/dev/null 2>&1
check "exits 2 on argv file with malformed JSON" 2 "$?"
rm -f "$TMP"

# Test 4: empty stdin -> exit 2
"$BINARY" </dev/null >/dev/null 2>&1
check "exits 2 on empty stdin" 2 "$?"

# Test 5: stderr message is useful, not silent
STDERR="$(echo '{bad}' | "$BINARY" 2>&1 >/dev/null || true)"
case "$STDERR" in
    *"Invalid plan JSON"*)
        echo "  PASS  stderr contains 'Invalid plan JSON' on bad input"
        PASS=$((PASS + 1))
        ;;
    *)
        echo "  FAIL  stderr missing useful error message (got: $STDERR)"
        FAIL=$((FAIL + 1))
        ;;
esac

echo ""
echo "==> $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
