#!/bin/bash
set -e

# Setup
TEST_DIR="tests/tmp_build"
mkdir -p "$TEST_DIR"
MOCK_XELATEX="$(pwd)/tests/mock_xelatex.sh"
BUILD_SCRIPT="./scripts/latex_build.sh"

# Helper to run the build script with mocked xelatex
run_build() {
    # We export the function to override xelatex? No, bash functions don't work like that easily in scripts calling scripts.
    # We will put the mock directory in PATH.

    # Create a wrapper named xelatex in tests/bin
    mkdir -p tests/bin
    ln -sf "$MOCK_XELATEX" tests/bin/xelatex

    export PATH="$(pwd)/tests/bin:$PATH"

    "$BUILD_SCRIPT" "$TEST_DIR" "test.tex"
}

echo "Test 1: Clean build, no rerun needed"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
export FORCE_RERUN=0
run_build

RUN_COUNT=$(<"$TEST_DIR/run_count")
if [ "$RUN_COUNT" -eq 1 ]; then
    echo "PASS: Ran once."
else
    echo "FAIL: Expected 1 run, got $RUN_COUNT"
    exit 1
fi

echo "Test 2: Build requiring rerun"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
export FORCE_RERUN=1
run_build

RUN_COUNT=$(<"$TEST_DIR/run_count")
if [ "$RUN_COUNT" -eq 2 ]; then
    echo "PASS: Ran twice."
else
    echo "FAIL: Expected 2 runs, got $RUN_COUNT"
    exit 1
fi

echo "All tests passed."
