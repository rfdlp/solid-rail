#!/bin/bash

# SolidRail Gem Release Script
# This script helps automate the gem release process

set -e

echo "🚂 SolidRail Gem Release Script"
echo "================================"

# Check if we're on the main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Error: You must be on the main branch to release"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Check if there are uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Error: You have uncommitted changes"
    echo "Please commit or stash your changes before releasing"
    git status --short
    exit 1
fi

# Get current version
CURRENT_VERSION=$(ruby -e "require_relative 'lib/solidrail/version'; puts SolidRail::VERSION")
echo "📦 Current version: $CURRENT_VERSION"

# Ask for new version
echo ""
echo "Enter the new version (e.g., 0.1.1, 0.2.0, 1.0.0):"
read -r NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    echo "❌ Error: Version cannot be empty"
    exit 1
fi

echo ""
echo "🔄 Updating version to $NEW_VERSION..."

# Update version in lib/solidrail/version.rb
sed -i.bak "s/VERSION = '.*'/VERSION = '$NEW_VERSION'/" lib/solidrail/version.rb
rm lib/solidrail/version.rb.bak

# Update CHANGELOG.md
sed -i.bak "s/## \[Unreleased\]/## [Unreleased]\n\n## [$NEW_VERSION] - $(date +%Y-%m-%d)/" CHANGELOG.md
rm CHANGELOG.md.bak

# Run tests
echo ""
echo "🧪 Running tests..."
bundle exec rspec

# Run RuboCop
echo ""
echo "🔍 Running RuboCop..."
bundle exec rubocop

# Build the gem
echo ""
echo "🔨 Building gem..."
bundle exec rake build

# Test the built gem
echo ""
echo "🧪 Testing built gem..."
gem install pkg/solidrail-$NEW_VERSION.gem --local

# Show gem info
echo ""
echo "📋 Gem information:"
gem info solidrail

# Ask for confirmation
echo ""
echo "✅ Ready to release version $NEW_VERSION"
echo "This will:"
echo "  - Tag the release"
echo "  - Push to GitHub"
echo "  - Push to RubyGems"
echo ""
echo "Continue? (y/N)"
read -r CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "❌ Release cancelled"
    exit 1
fi

# Commit changes
echo ""
echo "📝 Committing changes..."
git add .
git commit -m "Release version $NEW_VERSION"

# Create and push tag
echo ""
echo "🏷️  Creating tag..."
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"
git push origin main
git push origin "v$NEW_VERSION"

# Push to RubyGems
echo ""
echo "📦 Pushing to RubyGems..."
gem push pkg/solidrail-$NEW_VERSION.gem

echo ""
echo "🎉 Successfully released SolidRail v$NEW_VERSION!"
echo ""
echo "📋 What's next:"
echo "  - Check the release on RubyGems: https://rubygems.org/gems/solidrail"
echo "  - Verify the GitHub release: https://github.com/rfdlp/solid-rail/releases"
echo "  - Update documentation if needed"
echo "  - Share the release on social media!"
echo ""
echo "🚂 Happy coding with SolidRail!" 