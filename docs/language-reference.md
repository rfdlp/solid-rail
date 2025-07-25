# 🚂 SolidRail Language Reference

This document provides a comprehensive reference for translating Ruby code to Solidity using SolidRail. It covers syntax mappings, type conversions, patterns, and best practices.

## 📋 Table of Contents

- [Basic Syntax](#basic-syntax)
- [Type System](#type-system)
- [Classes and Contracts](#classes-and-contracts)
- [Methods and Functions](#methods-and-functions)
- [Variables and Storage](#variables-and-storage)
- [Control Flow](#control-flow)
- [Error Handling](#error-handling)
- [Events and Logging](#events-and-logging)
- [Modifiers and Access Control](#modifiers-and-access-control)
- [Inheritance](#inheritance)
- [Libraries and Interfaces](#libraries-and-interfaces)
- [Gas Optimization](#gas-optimization)
- [Security Patterns](#security-patterns)
- [Common Patterns](#common-patterns)

## 🔤 Basic Syntax

### Comments

```ruby
# Single line comment
=begin
  Multi-line
  comment block
=end
```

Translates to:

```solidity
// Single line comment
/*
  Multi-line
  comment block
*/
```

### String Literals

```ruby
# Ruby strings
name = "SolidRail"
symbol = :transfer
```

Translates to:

```solidity
// Solidity strings
string memory name = "SolidRail";
string memory symbol = "transfer";
```

## 🎯 Type System

### Basic Type Mappings

| Ruby Type | Solidity Type                 | Description                           |
| --------- | ----------------------------- | ------------------------------------- |
| `Integer` | `uint256`                     | Unsigned 256-bit integer              |
| `Float`   | `uint256`                     | Converted to integer (precision lost) |
| `String`  | `string memory`               | Dynamic string                        |
| `Symbol`  | `string memory`               | Converted to string                   |
| `Array`   | `uint256[]`                   | Dynamic array                         |
| `Hash`    | `mapping(uint256 => uint256)` | Key-value mapping                     |
| `Boolean` | `bool`                        | Boolean value                         |
| `Nil`     | Not supported                 | Use explicit checks                   |

### Type Declarations

```ruby
# Ruby type hints (optional)
def transfer(to: String, amount: Integer)
  # method body
end
```

Translates to:

```solidity
// Solidity explicit types
function transfer(string memory to, uint256 amount) public {
    // function body
}
```

### Type Conversion Examples

```ruby
# Ruby
@total_supply = 1_000_000
@name = "MyToken"
@decimals = 18
@owner = msg.sender
```

Translates to:

```solidity
// Solidity
uint256 public totalSupply = 1000000;
string public name = "MyToken";
uint8 public decimals = 18;
address public owner = msg.sender;
```

## 🏗️ Classes and Contracts

### Basic Class Structure

```ruby
class Token < ERC20
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @total_supply = 1_000_000
  end
end
```

Translates to:

```solidity
contract Token is ERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 1000000;
    }
}
```

### Contract Inheritance

```ruby
class MyToken < ERC20
  include Pausable
  include Ownable

  def initialize(name, symbol)
    super(name, symbol)
    @paused = false
  end
end
```

Translates to:

```solidity
contract MyToken is ERC20, Pausable, Ownable {
    bool public paused;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        paused = false;
    }
}
```

## 🔧 Methods and Functions

### Method Visibility

```ruby
# Public method (default)
def transfer(to, amount)
  # implementation
end

# Private method
private def internal_transfer(from, to, amount)
  # implementation
end

# External method (for external calls)
external def mint(to, amount)
  # implementation
end
```

Translates to:

```solidity
// Public function (default)
function transfer(address to, uint256 amount) public {
    // implementation
}

// Private function
function internalTransfer(address from, address to, uint256 amount) private {
    // implementation
}

// External function
function mint(address to, uint256 amount) external {
    // implementation
}
```

### Function Modifiers

```ruby
# Function with modifier
def transfer(to, amount)
  require(!paused, "Contract is paused")
  require(balance_of(msg.sender) >= amount, "Insufficient balance")

  @balances[msg.sender] -= amount
  @balances[to] += amount
  emit Transfer(msg.sender, to, amount)
end
```

Translates to:

```solidity
// Function with modifiers
function transfer(address to, uint256 amount) public {
    require(!paused, "Contract is paused");
    require(balanceOf(msg.sender) >= amount, "Insufficient balance");

    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
}
```

### Pure and View Functions

```ruby
# View function (read-only)
def balance_of(owner)
  @balances[owner] || 0
end

# Pure function (no state access)
def calculate_fee(amount, fee_rate)
  amount * fee_rate / 10000
end
```

Translates to:

```solidity
// View function
function balanceOf(address owner) public view returns (uint256) {
    return balances[owner];
}

// Pure function
function calculateFee(uint256 amount, uint256 feeRate) public pure returns (uint256) {
    return amount * feeRate / 10000;
}
```

## 💾 Variables and Storage

### Instance Variables

```ruby
class Token
  def initialize
    @name = "MyToken"
    @symbol = "MTK"
    @decimals = 18
    @total_supply = 1_000_000
    @balances = {}
    @allowances = {}
  end
end
```

Translates to:

```solidity
contract Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    constructor() {
        name = "MyToken";
        symbol = "MTK";
        decimals = 18;
        totalSupply = 1000000;
    }
}
```

### Storage vs Memory

```ruby
# Storage variables (persistent)
@balances = {}
@total_supply = 0

# Local variables (temporary)
def transfer(to, amount)
  current_balance = @balances[msg.sender]
  new_balance = current_balance - amount
  @balances[msg.sender] = new_balance
end
```

Translates to:

```solidity
// Storage variables
mapping(address => uint256) public balances;
uint256 public totalSupply;

// Local variables
function transfer(address to, uint256 amount) public {
    uint256 currentBalance = balances[msg.sender];
    uint256 newBalance = currentBalance - amount;
    balances[msg.sender] = newBalance;
}
```

### Constants and Immutables

```ruby
class Token
  DECIMALS = 18
  MAX_SUPPLY = 1_000_000_000

  def initialize
    @decimals = DECIMALS
    @max_supply = MAX_SUPPLY
  end
end
```

Translates to:

```solidity
contract Token {
    uint8 public constant decimals = 18;
    uint256 public constant MAX_SUPPLY = 1000000000;

    uint8 public immutable decimals;
    uint256 public immutable maxSupply;

    constructor() {
        decimals = 18;
        maxSupply = MAX_SUPPLY;
    }
}
```

## 🔄 Control Flow

### Conditional Statements

```ruby
def transfer(to, amount)
  if @balances[msg.sender] < amount
    revert("Insufficient balance")
  elsif amount == 0
    revert("Amount must be greater than 0")
  else
    @balances[msg.sender] -= amount
    @balances[to] += amount
    emit Transfer(msg.sender, to, amount)
  end
end
```

Translates to:

```solidity
function transfer(address to, uint256 amount) public {
    if (balances[msg.sender] < amount) {
        revert("Insufficient balance");
    } else if (amount == 0) {
        revert("Amount must be greater than 0");
    } else {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }
}
```

### Loops

```ruby
def batch_transfer(recipients, amounts)
  total_amount = 0

  # Calculate total
  amounts.each do |amount|
    total_amount += amount
  end

  # Validate total
  require(@balances[msg.sender] >= total_amount, "Insufficient balance")

  # Execute transfers
  recipients.each_with_index do |recipient, index|
    amount = amounts[index]
    @balances[msg.sender] -= amount
    @balances[recipient] += amount
    emit Transfer(msg.sender, recipient, amount)
  end
end
```

Translates to:

```solidity
function batchTransfer(address[] memory recipients, uint256[] memory amounts) public {
    uint256 totalAmount = 0;

    // Calculate total
    for (uint256 i = 0; i < amounts.length; i++) {
        totalAmount += amounts[i];
    }

    // Validate total
    require(balances[msg.sender] >= totalAmount, "Insufficient balance");

    // Execute transfers
    for (uint256 i = 0; i < recipients.length; i++) {
        uint256 amount = amounts[i];
        balances[msg.sender] -= amount;
        balances[recipients[i]] += amount;
        emit Transfer(msg.sender, recipients[i], amount);
    }
}
```

## ⚠️ Error Handling

### Require Statements

```ruby
def transfer(to, amount)
  require(to != address(0), "Transfer to zero address")
  require(amount > 0, "Amount must be greater than 0")
  require(@balances[msg.sender] >= amount, "Insufficient balance")

  @balances[msg.sender] -= amount
  @balances[to] += amount
  emit Transfer(msg.sender, to, amount)
end
```

Translates to:

```solidity
function transfer(address to, uint256 amount) public {
    require(to != address(0), "Transfer to zero address");
    require(amount > 0, "Amount must be greater than 0");
    require(balances[msg.sender] >= amount, "Insufficient balance");

    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
}
```

### Custom Errors

```ruby
# Define custom errors
class InsufficientBalanceError < StandardError; end
class ZeroAddressError < StandardError; end

def transfer(to, amount)
  raise ZeroAddressError, "Transfer to zero address" if to == address(0)
  raise InsufficientBalanceError, "Insufficient balance" if @balances[msg.sender] < amount

  @balances[msg.sender] -= amount
  @balances[to] += amount
  emit Transfer(msg.sender, to, amount)
end
```

Translates to:

```solidity
// Custom errors
error InsufficientBalance();
error ZeroAddress();

function transfer(address to, uint256 amount) public {
    if (to == address(0)) revert ZeroAddress();
    if (balances[msg.sender] < amount) revert InsufficientBalance();

    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
}
```

## 📢 Events and Logging

### Event Definitions

```ruby
class Token
  # Event definitions
  event Transfer(from: Address, to: Address, amount: Uint256)
  event Approval(owner: Address, spender: Address, amount: Uint256)
  event Minted(to: Address, amount: Uint256)
  event Burned(from: Address, amount: Uint256)

  def initialize
    @name = "MyToken"
    @symbol = "MTK"
  end
end
```

Translates to:

```solidity
contract Token {
    // Event definitions
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);

    string public name;
    string public symbol;

    constructor() {
        name = "MyToken";
        symbol = "MTK";
    }
}
```

### Emitting Events

```ruby
def transfer(to, amount)
  require(@balances[msg.sender] >= amount, "Insufficient balance")

  @balances[msg.sender] -= amount
  @balances[to] += amount

  emit Transfer(msg.sender, to, amount)
end

def mint(to, amount)
  require(msg.sender == @owner, "Only owner can mint")

  @total_supply += amount
  @balances[to] += amount

  emit Minted(to, amount)
  emit Transfer(address(0), to, amount)
end
```

Translates to:

```solidity
function transfer(address to, uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");

    balances[msg.sender] -= amount;
    balances[to] += amount;

    emit Transfer(msg.sender, to, amount);
}

function mint(address to, uint256 amount) public {
    require(msg.sender == owner, "Only owner can mint");

    totalSupply += amount;
    balances[to] += amount;

    emit Minted(to, amount);
    emit Transfer(address(0), to, amount);
}
```

## 🔒 Modifiers and Access Control

### Function Modifiers

```ruby
class Token
  def initialize
    @owner = msg.sender
    @paused = false
  end

  # Modifier: only owner
  def only_owner
    require(msg.sender == @owner, "Only owner can call this function")
  end

  # Modifier: when not paused
  def when_not_paused
    require(!@paused, "Contract is paused")
  end

  def pause
    only_owner
    @paused = true
    emit Paused(msg.sender)
  end

  def transfer(to, amount)
    when_not_paused
    # transfer logic
  end
end
```

Translates to:

```solidity
contract Token {
    address public owner;
    bool public paused;

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    // Modifier: only owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Modifier: when not paused
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    function transfer(address to, uint256 amount) public whenNotPaused {
        // transfer logic
    }
}
```

### Access Control Patterns

```ruby
class Token
  def initialize
    @owner = msg.sender
    @operators = {}
  end

  def add_operator(operator)
    require(msg.sender == @owner, "Only owner can add operators")
    @operators[operator] = true
    emit OperatorAdded(operator)
  end

  def remove_operator(operator)
    require(msg.sender == @owner, "Only owner can remove operators")
    @operators[operator] = false
    emit OperatorRemoved(operator)
  end

  def only_operator
    require(@operators[msg.sender], "Only operators can call this function")
  end

  def mint(to, amount)
    only_operator
    # mint logic
  end
end
```

Translates to:

```solidity
contract Token {
    address public owner;
    mapping(address => bool) public operators;

    constructor() {
        owner = msg.sender;
    }

    function addOperator(address operator) public {
        require(msg.sender == owner, "Only owner can add operators");
        operators[operator] = true;
        emit OperatorAdded(operator);
    }

    function removeOperator(address operator) public {
        require(msg.sender == owner, "Only owner can remove operators");
        operators[operator] = false;
        emit OperatorRemoved(operator);
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Only operators can call this function");
        _;
    }

    function mint(address to, uint256 amount) public onlyOperator {
        // mint logic
    }
}
```

## 🏗️ Inheritance

### Single Inheritance

```ruby
class MyToken < ERC20
  def initialize(name, symbol)
    super(name, symbol)
    @custom_feature = true
  end

  def custom_function
    # custom implementation
  end
end
```

Translates to:

```solidity
contract MyToken is ERC20 {
    bool public customFeature;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        customFeature = true;
    }

    function customFunction() public {
        // custom implementation
    }
}
```

### Multiple Inheritance (Mixins)

```ruby
class MyToken < ERC20
  include Pausable
  include Ownable
  include ReentrancyGuard

  def initialize(name, symbol)
    super(name, symbol)
    @owner = msg.sender
  end

  def transfer(to, amount)
    when_not_paused
    non_reentrant
    super(to, amount)
  end
end
```

Translates to:

```solidity
contract MyToken is ERC20, Pausable, Ownable, ReentrancyGuard {
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        owner = msg.sender;
    }

    function transfer(address to, uint256 amount) public override whenNotPaused nonReentrant {
        super.transfer(to, amount);
    }
}
```

## 📚 Libraries and Interfaces

### Library Usage

```ruby
class Token
  include SafeMath

  def transfer(to, amount)
    require(to != address(0), "Transfer to zero address")
    require(SafeMath.sub(@balances[msg.sender], amount) >= 0, "Insufficient balance")

    @balances[msg.sender] = SafeMath.sub(@balances[msg.sender], amount)
    @balances[to] = SafeMath.add(@balances[to], amount)

    emit Transfer(msg.sender, to, amount)
  end
end
```

Translates to:

```solidity
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Token {
    using SafeMath for uint256;

    function transfer(address to, uint256 amount) public {
        require(to != address(0), "Transfer to zero address");
        require(balances[msg.sender].sub(amount) >= 0, "Insufficient balance");

        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);

        emit Transfer(msg.sender, to, amount);
    }
}
```

### Interface Implementation

```ruby
# Interface definition
interface IERC20
  def total_supply
  def balance_of(owner)
  def transfer(to, amount)
  def allowance(owner, spender)
  def approve(spender, amount)
  def transfer_from(from, to, amount)
end

class Token < IERC20
  def total_supply
    @total_supply
  end

  def balance_of(owner)
    @balances[owner] || 0
  end

  # ... other interface methods
end
```

Translates to:

```solidity
// Interface definition
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract Token is IERC20 {
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) external view override returns (uint256) {
        return balances[owner];
    }

    // ... other interface methods
}
```

## ⛽ Gas Optimization

### Storage Optimization

```ruby
class Token
  def initialize
    # Pack related variables together
    @name = "MyToken"
    @symbol = "MTK"
    @decimals = 18
    @total_supply = 0
  end
end
```

Translates to:

```solidity
contract Token {
    // Pack variables efficiently
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    constructor() {
        name = "MyToken";
        symbol = "MTK";
        decimals = 18;
        totalSupply = 0;
    }
}
```

### Loop Optimization

```ruby
def batch_transfer(recipients, amounts)
  # Cache array length
  length = recipients.length

  for i in 0...length
    recipient = recipients[i]
    amount = amounts[i]

    require(@balances[msg.sender] >= amount, "Insufficient balance")
    @balances[msg.sender] -= amount
    @balances[recipient] += amount
    emit Transfer(msg.sender, recipient, amount)
  end
end
```

Translates to:

```solidity
function batchTransfer(address[] memory recipients, uint256[] memory amounts) public {
    // Cache array length
    uint256 length = recipients.length;

    for (uint256 i = 0; i < length; i++) {
        address recipient = recipients[i];
        uint256 amount = amounts[i];

        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }
}
```

## 🛡️ Security Patterns

### Reentrancy Protection

```ruby
class Token
  include ReentrancyGuard

  def withdraw(amount)
    non_reentrant
    require(@balances[msg.sender] >= amount, "Insufficient balance")

    @balances[msg.sender] -= amount
    msg.sender.transfer(amount)
  end
end
```

Translates to:

```solidity
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Token is ReentrancyGuard {
    function withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
```

### Access Control

```ruby
class Token
  def initialize
    @owner = msg.sender
    @paused = false
  end

  def pause
    require(msg.sender == @owner, "Only owner can pause")
    @paused = true
    emit Paused(msg.sender)
  end

  def unpause
    require(msg.sender == @owner, "Only owner can unpause")
    @paused = false
    emit Unpaused(msg.sender)
  end

  def transfer(to, amount)
    require(!@paused, "Contract is paused")
    # transfer logic
  end
end
```

Translates to:

```solidity
contract Token {
    address public owner;
    bool public paused;

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }

    function transfer(address to, uint256 amount) public {
        require(!paused, "Contract is paused");
        // transfer logic
    }
}
```

## 🔄 Common Patterns

### ERC20 Token Pattern

```ruby
class MyToken < ERC20
  def initialize(name, symbol)
    super(name, symbol)
    @owner = msg.sender
    @max_supply = 1_000_000_000
  end

  def mint(to, amount)
    require(msg.sender == @owner, "Only owner can mint")
    require(@total_supply + amount <= @max_supply, "Exceeds max supply")

    @total_supply += amount
    @balances[to] += amount
    emit Transfer(address(0), to, amount)
  end

  def burn(amount)
    require(@balances[msg.sender] >= amount, "Insufficient balance")

    @balances[msg.sender] -= amount
    @total_supply -= amount
    emit Transfer(msg.sender, address(0), amount)
  end
end
```

Translates to:

```solidity
contract MyToken is ERC20 {
    address public owner;
    uint256 public maxSupply;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        owner = msg.sender;
        maxSupply = 1000000000;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        require(totalSupply() + amount <= maxSupply, "Exceeds max supply");

        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
    }
}
```

### Crowdsale Pattern

```ruby
class Crowdsale
  def initialize(token, rate, wallet)
    @token = token
    @rate = rate
    @wallet = wallet
    @wei_raised = 0
  end

  def buy_tokens(beneficiary)
    require(beneficiary != address(0), "Invalid beneficiary")
    require(msg.value > 0, "Must send ETH")

    wei_amount = msg.value
    token_amount = wei_amount * @rate

    @wei_raised += wei_amount
    @token.mint(beneficiary, token_amount)

    @wallet.transfer(wei_amount)
    emit TokensPurchased(msg.sender, beneficiary, wei_amount, token_amount)
  end
end
```

Translates to:

```solidity
contract Crowdsale {
    IERC20 public token;
    uint256 public rate;
    address payable public wallet;
    uint256 public weiRaised;

    constructor(IERC20 _token, uint256 _rate, address payable _wallet) {
        token = _token;
        rate = _rate;
        wallet = _wallet;
    }

    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0), "Invalid beneficiary");
        require(msg.value > 0, "Must send ETH");

        uint256 weiAmount = msg.value;
        uint256 tokenAmount = weiAmount * rate;

        weiRaised += weiAmount;
        token.mint(beneficiary, tokenAmount);

        wallet.transfer(weiAmount);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokenAmount);
    }
}
```

## 📝 Best Practices

### 1. **Use Explicit Types**

Always specify types in function parameters and return values for better clarity and gas optimization.

### 2. **Validate Inputs**

Always validate function parameters and state conditions before processing.

### 3. **Use Events for Important State Changes**

Emit events for all important state changes to enable off-chain monitoring.

### 4. **Implement Access Control**

Use modifiers and access control patterns to restrict function access appropriately.

### 5. **Handle Errors Gracefully**

Use custom errors and require statements with descriptive messages.

### 6. **Optimize for Gas**

- Pack related storage variables together
- Use appropriate data types
- Cache array lengths in loops
- Avoid unnecessary storage reads

### 7. **Follow Security Patterns**

- Implement reentrancy protection
- Use safe math operations
- Validate all external calls
- Implement proper access controls

### 8. **Test Thoroughly**

Write comprehensive tests for all functions and edge cases.

## 🔗 Additional Resources

- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [SolidRail Examples](https://github.com/rfdlp/solid-rail/tree/main/examples)
- [Ethereum Development Guide](https://ethereum.org/developers/)

---

This language reference provides a comprehensive guide for translating Ruby code to Solidity using SolidRail. For more examples and advanced patterns, check out the [examples directory](https://github.com/rfdlp/solid-rail/tree/main/examples) and [getting started guide](getting-started.md).
