# Contributing to SolidRail

Thank you for your interest in contributing to SolidRail! This document provides guidelines and information for contributors.

## Getting Started

### Prerequisites

- Ruby 3.0 or higher
- Bundler
- Git

### Development Setup

1. Fork the repository
2. Clone your fork:

   ```bash
   git clone https://github.com/your-username/solidrail.git
   cd solidrail
   ```

3. Install dependencies:

   ```bash
   bundle install
   ```

4. Run tests to ensure everything works:
   ```bash
   bundle exec rspec
   ```

## Development Workflow

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/parser_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Code Style

We use RuboCop for code style enforcement:

```bash
# Check code style
bundle exec rubocop

# Auto-fix style issues
bundle exec rubocop -a
```

### Building the Gem

```bash
# Build the gem
bundle exec rake build

# Install locally
bundle exec rake install
```

## Project Structure

```
solidrail/
├── lib/solidrail/          # Main library code
│   ├── parser.rb           # Ruby AST parsing
│   ├── mapper.rb           # Type and syntax mapping
│   ├── generator.rb        # Solidity code generation
│   ├── optimizer.rb        # Code optimization
│   ├── validator.rb        # Code validation
│   └── compiler.rb         # Main compiler
├── bin/                    # CLI executables
├── spec/                   # RSpec tests
├── examples/               # Example contracts
├── docs/                   # Documentation
└── docs/                   # Documentation
```

## Making Changes

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- Write code following the existing patterns
- Add tests for new functionality
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run all tests
bundle exec rspec

# Run linting
bundle exec rubocop

# Test the CLI
ruby bin/solidrail version
```

### 4. Commit Your Changes

Use conventional commit messages:

```
feat: add support for custom types
fix: resolve issue with array mapping
docs: update getting started guide
test: add tests for parser module
```

### 5. Push and Create a Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## Code Guidelines

### Ruby Code Style

- Use single quotes for strings unless interpolation is needed
- Use 2 spaces for indentation
- Keep methods under 20 lines
- Use meaningful variable and method names
- Add comments for complex logic

### Testing

- Write tests for all new functionality
- Aim for 80%+ code coverage
- Use descriptive test names
- Test both success and failure cases

### Documentation

- Update README.md for user-facing changes
- Add inline documentation for complex methods
- Update examples if syntax changes

## Areas for Contribution

### High Priority

- [ ] Complete Ruby AST parsing implementation
- [ ] Implement comprehensive type mapping
- [ ] Add more Solidity code generation patterns
- [ ] Improve error handling and validation
- [ ] Add more example contracts

### Medium Priority

- [ ] Add gas optimization strategies
- [ ] Implement security analysis
- [ ] Create IDE extensions
- [ ] Add support for more Ruby features
- [ ] Improve documentation

### Low Priority

- [ ] Add support for other blockchain platforms
- [ ] Create web interface
- [ ] Add performance benchmarks
- [ ] Create migration tools

## Getting Help

- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Email**: Contact us at team@solidrail.dev

## License

By contributing to SolidRail, you agree that your contributions will be licensed under the MIT License.
