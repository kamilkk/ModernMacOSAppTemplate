#!/bin/bash

# Swift Format Build Script
# This script runs swift-format for code formatting

set -e

echo "🔄 Running Swift Format..."

# Check if swift-format is installed
if ! command -v swift-format &> /dev/null; then
    echo "❌ swift-format not found. Installing via Homebrew..."
    brew install swift-format
fi

# Format all Swift files
find Sources Tests -name "*.swift" -type f | while read file; do
    swift-format --in-place "$file"
done

echo "✅ Swift Format completed successfully!"
