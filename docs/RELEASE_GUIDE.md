# 🚂 SolidRail Release Guide

This guide walks you through the process of releasing SolidRail as a Ruby gem.

## 📋 Prerequisites

Before releasing, ensure you have:

1. **RubyGems Account**: Sign up at [rubygems.org](https://rubygems.org)
2. **GitHub Account**: Your repository should be on GitHub
3. **Two-Factor Authentication**: Enable 2FA on RubyGems for security
4. **API Key**: Get your RubyGems API key from your account settings

## 🔧 Setup

### 1. Install Required Tools

```bash
# Install bundler if not already installed
gem install bundler

# Install development dependencies
bundle install
```

### 2. Configure RubyGems

```bash
# Login to RubyGems (you'll be prompted for credentials)
gem login

# Verify your credentials
gem whoami
```

## 🚀 Release Process

### Option 1: Automated Release (Recommended)

Use our release script for a streamlined process:

```bash
# Make the script executable (if not already done)
chmod +x scripts/release.sh

# Run the release script
./scripts/release.sh
```

The script will:

- ✅ Check you're on the main branch
- ✅ Verify no uncommitted changes
- ✅ Update version numbers
- ✅ Run tests and linting
- ✅ Build the gem
- ✅ Test the built gem
- ✅ Create git tag
- ✅ Push to GitHub
- ✅ Push to RubyGems

### Option 2: Manual Release

If you prefer manual control:

#### Step 1: Update Version

```bash
# Edit lib/solidrail/version.rb
# Change VERSION = '0.1.0' to your new version
```

#### Step 2: Update CHANGELOG

```bash
# Edit CHANGELOG.md
# Move items from [Unreleased] to [NEW_VERSION]
# Add release date
```

#### Step 3: Test Everything

```bash
# Run tests
bundle exec rspec

# Run linting
bundle exec rubocop

# Build gem
bundle exec rake build

# Test the built gem
gem install pkg/solidrail-0.1.0.gem --local
```

#### Step 4: Commit and Tag

```bash
# Commit changes
git add .
git commit -m "Release version 0.1.0"

# Create tag
git tag -a "v0.1.0" -m "Release version 0.1.0"

# Push to GitHub
git push origin main
git push origin v0.1.0
```

#### Step 5: Release to RubyGems

```bash
# Push to RubyGems
gem push pkg/solidrail-0.1.0.gem
```

## 📦 Versioning Strategy

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR.MINOR.PATCH** (e.g., 1.2.3)
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Examples:

- `0.1.0` → `0.1.1` (bug fix)
- `0.1.1` → `0.2.0` (new feature)
- `0.2.0` → `1.0.0` (stable release)
- `1.0.0` → `1.0.1` (bug fix)

## 🔍 Pre-Release Checklist

Before releasing, verify:

- [ ] All tests pass (`bundle exec rspec`)
- [ ] Code follows style guidelines (`bundle exec rubocop`)
- [ ] Documentation is up to date
- [ ] CHANGELOG.md is updated
- [ ] Version number is correct
- [ ] Gem builds successfully (`bundle exec rake build`)
- [ ] Gem installs and works (`gem install pkg/solidrail-X.X.X.gem --local`)
- [ ] No sensitive data in the gem
- [ ] License file is included
- [ ] README.md is comprehensive

## 🎯 Post-Release Tasks

After a successful release:

1. **Verify the Release**:

   ```bash
   # Check RubyGems
   gem info solidrail

   # Test installation
   gem install solidrail
   ```

2. **Update Documentation**:

   - Update GitHub Pages if needed
   - Update API documentation
   - Update examples

3. **Announce the Release**:

   - Create GitHub release notes
   - Share on social media
   - Update community channels

4. **Monitor Feedback**:
   - Watch for issues on GitHub
   - Monitor RubyGems download stats
   - Respond to user feedback

## 🛠️ Troubleshooting

### Common Issues

#### "Gem already exists"

```bash
# Check if version already exists
gem list solidrail --remote

# Use a new version number
```

#### "Authentication failed"

```bash
# Re-login to RubyGems
gem logout
gem login
```

#### "Permission denied"

```bash
# Check file permissions
chmod +x scripts/release.sh
```

#### "Build failed"

```bash
# Check gemspec syntax
gem build solidrail.gemspec

# Check for missing files
gem spec solidrail.gemspec
```

### Getting Help

- Check [RubyGems documentation](https://guides.rubygems.org/)
- Review [RubyGems best practices](https://guides.rubygems.org/make-your-own-gem/)
- Ask in the Ruby community

## 📈 Release Metrics

Track your release success:

- **Downloads**: Check RubyGems stats
- **GitHub Stars**: Monitor repository growth
- **Issues**: Track bug reports and feature requests
- **Community**: Monitor discussions and contributions

## 🔄 Continuous Release

For automated releases, consider:

1. **GitHub Actions**: Set up automated testing
2. **Release Automation**: Use tools like `release-it`
3. **Version Management**: Use tools like `bump` or `gem-release`

## 🎉 Congratulations!

You've successfully released SolidRail!

Remember:

- Keep releases regular and predictable
- Maintain high code quality
- Engage with your community
- Document breaking changes clearly
- Test thoroughly before each release

Happy releasing! 🚂✨
