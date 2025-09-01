#!/bin/bash

# SwiftGen Build Script
# This script runs SwiftGen to generate code from resources

set -e

echo "🔄 Running SwiftGen..."

# Check if swiftgen is installed
if ! command -v swiftgen &> /dev/null; then
    echo "❌ SwiftGen not found. Installing via Homebrew..."
    brew install swiftgen
fi

# Run SwiftGen
swiftgen config run --config swiftgen.yml

echo "✅ SwiftGen code generation completed!"
