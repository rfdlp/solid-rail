# Getting Started with SolidRail

SolidRail is a transpiler that allows you to write smart contracts in Ruby and generate equivalent Solidity code. This guide will help you get started with your first smart contract.

## Installation

```bash
gem install solidrail
```

Or add to your Gemfile:

```ruby
gem 'solidrail'
```

## Your First Smart Contract

Let's create a simple token contract:

```ruby
# my_token.rb
class MyToken < ERC20
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

## Compiling Your Contract

```bash
solidrail compile my_token.rb
```

This will generate a Solidity file `my_token.sol` with the equivalent code.

## Understanding the Translation

### Ruby Class → Solidity Contract

```ruby
class MyToken < ERC20
```

Becomes:

```solidity
contract MyToken is ERC20 {
```

### Ruby Methods → Solidity Functions

```ruby
def transfer(to, amount)
  # method body
end
```

Becomes:

```solidity
function transfer(address to, uint256 amount) public {
    // function body
}
```

### Ruby Instance Variables → Solidity State Variables

```ruby
@balances = {}
```

Becomes:

```solidity
mapping(address => uint256) public balances;
```

## Key Concepts

### 1. Type Mapping

SolidRail automatically maps Ruby types to Solidity types:

- `Integer` → `uint256`
- `String` → `string`
- `Array` → `uint256[]`
- `Hash` → `mapping`

### 2. Smart Contract Patterns

SolidRail recognizes common smart contract patterns:

- `require()` → Solidity `require()`
- `emit` → Solidity `emit`
- `msg.sender` → Solidity `msg.sender`

### 3. Security Features

The transpiler includes security best practices:

- Automatic overflow checks
- Reentrancy guards
- Access control patterns

## Next Steps

- Read the [Language Reference](language-reference.md) for detailed syntax
- Check out [Examples](../examples/) for more complex contracts
- Learn about [Best Practices](best-practices.md) for secure contracts
