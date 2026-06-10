#!/bin/bash
echo "🚀 Compiling Typst Navigator..."
cd "$(dirname "$0")"

# Docs
for file in docs/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done

# Examples
for file in examples/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done

# Tests
for file in tests/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done
