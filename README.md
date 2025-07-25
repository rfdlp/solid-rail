# SolidRail - Ruby to Solidity Transpiler

[![Build Status](https://github.com/solidrail/solidrail/workflows/CI/badge.svg)](https://github.com/solidrail/solidrail/actions)
[![Gem Version](https://badge.fury.io/rb/solidrail.svg)](https://badge.fury.io/rb/solidrail)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> Write smart contracts in Ruby, generate production-ready Solidity code

SolidRail is a transpiler that allows Ruby developers to write smart contracts using familiar Ruby syntax while generating equivalent Solidity code for deployment on Ethereum and other EVM-compatible blockchains.

## 🚀 Features

- **Ruby Syntax**: Write contracts using familiar Ruby syntax and conventions
- **Solidity Output**: Generate production-ready Solidity code
- **Type Safety**: Automatic type inference and validation
- **Gas Optimization**: Built-in gas optimization strategies
- **Security**: Security best practices and vulnerability detection
- **Testing**: Comprehensive test suite and integration testing

## 📦 Installation

```bash
gem install solidrail
```

Or add to your Gemfile:

```ruby
gem 'solidrail'
```

## 🎯 Quick Start

### Basic Contract

```ruby
# token.rb
class Token < ERC20
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @total_supply = 1000000
    @balances = {}
  end

  def transfer(to, amount)
    require(balance_of(msg.sender) >= amount, "Insufficient balance")
    @balances[msg.sender] -= amount
    @balances[to] += amount
    emit Transfer(msg.sender, to, amount)
  end

  def balance_of(owner)
    @balances[owner] || 0
  end
end
```

### Generate Solidity

```bash
solidrail compile token.rb
```

### Generated Solidity

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 1000000;
    }

    function transfer(address to, uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner] != 0 ? balances[owner] : 0;
    }
}
```

## 🏗️ Architecture

### Core Components

1. **Ruby Parser**: Parses Ruby source code into AST using `Ripper`
2. **Type Mapper**: Maps Ruby types to Solidity types
3. **Code Generator**: Transforms AST into Solidity code
4. **Optimizer**: Applies gas and security optimizations
5. **Validator**: Validates generated code and provides feedback

### Project Structure

```
solidrail/
├── lib/
│   └── solidrail/
│       ├── parser/          # Ruby AST parsing
│       ├── mapper/          # Type and syntax mapping
│       ├── generator/       # Solidity code generation
│       ├── optimizer/       # Code optimization
│       └── validator/       # Code validation
├── spec/                    # RSpec tests
├── examples/               # Example contracts
├── docs/                   # Documentation
└── bin/                    # CLI executables
```

## 🧪 Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/parser_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 📚 Documentation

- [Getting Started](docs/getting-started.md)
- [Language Reference](docs/language-reference.md)
- [Best Practices](docs/best-practices.md)
- [API Reference](docs/api-reference.md)
- [Examples](examples/)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/solidrail/solidrail.git
cd solidrail

# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Solidity Documentation](https://docs.soliditylang.org/) for language reference
- [Ruby Ripper](https://ruby-doc.org/stdlib-2.7.0/libdoc/ripper/rdoc/Ripper.html) for AST parsing
- [OpenZeppelin](https://openzeppelin.com/) for contract templates

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/solidrail/solidrail/issues)
- **Discussions**: [GitHub Discussions](https://github.com/solidrail/solidrail/discussions)
- **Email**: support@solidrail.dev
- **Discord**: [SolidRail Community](https://discord.gg/solidrail)

---

**Made with ❤️ for the Ruby and Ethereum communities**
