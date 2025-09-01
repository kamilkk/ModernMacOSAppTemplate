#!/bin/bash

# Main Build Script
# This script runs all build tools in the correct order

set -e

echo "🚀 Starting build process..."

# Make scripts executable
chmod +x Scripts/*.sh

# 1. Generate resources with SwiftGen
echo "📦 Step 1: Generating resources..."
./Scripts/swiftgen.sh

# 2. Format code with swift-format
echo "🎨 Step 2: Formatting code..."
./Scripts/swift-format.sh

# 3. Run SwiftLint for code quality
echo "🔍 Step 3: Checking code quality..."
./Scripts/swiftlint.sh

# 4. Build the project
echo "🔨 Step 4: Building project..."
swift build

echo "✅ Build process completed successfully!"
