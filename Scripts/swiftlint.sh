#!/bin/bash

# SwiftLint Build Script
# This script runs SwiftLint for code quality checking

set -e

echo "🔄 Running SwiftLint..."

# Check if swiftlint is installed
if ! command -v swiftlint &> /dev/null; then
    echo "❌ SwiftLint not found. Installing via Homebrew..."
    brew install swiftlint
fi

# Run SwiftLint
swiftlint --strict

echo "✅ SwiftLint completed successfully!"
