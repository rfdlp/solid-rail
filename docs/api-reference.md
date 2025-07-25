# 🚂 SolidRail API Reference

This document provides a comprehensive API reference for SolidRail, covering all classes, methods, configuration options, and usage patterns.

## 📋 Table of Contents

- [Core Module](#core-module)
- [Parser API](#parser-api)
- [Mapper API](#mapper-api)
- [Generator API](#generator-api)
- [Optimizer API](#optimizer-api)
- [Validator API](#validator-api)
- [Compiler API](#compiler-api)
- [Configuration](#configuration)
- [Error Classes](#error-classes)
- [CLI Reference](#cli-reference)
- [Type System](#type-system)
- [Examples](#examples)

## 🏗️ Core Module

### `SolidRail`

The main module that provides the core transpilation functionality.

```ruby
require 'solidrail'

# Basic usage
SolidRail.compile(ruby_code)

# With configuration
SolidRail.configure do |config|
  config.solidity_version = '0.8.30'
  config.optimization_enabled = true
  config.gas_optimization = true
  config.security_checks = true
end
```

## 🔍 Parser API

### `SolidRail::Parser`

Handles parsing Ruby source code into an Abstract Syntax Tree (AST).

#### Methods

##### `parse(source_code)`

Parses Ruby source code into an AST.

**Parameters:**

- `source_code` (String) - Ruby source code to parse

**Returns:**

- `ASTNode` - Root node of the parsed AST

**Example:**

```ruby
require 'solidrail'

ruby_code = <<~RUBY
  class Token < ERC20
    def initialize(name, symbol)
      @name = name
      @symbol = symbol
    end
  end
RUBY

ast = SolidRail::Parser.parse(ruby_code)
puts ast.to_s
```

##### `parse_file(file_path)`

Parses a Ruby file into an AST.

**Parameters:**

- `file_path` (String) - Path to the Ruby file

**Returns:**

- `ASTNode` - Root node of the parsed AST

**Example:**

```ruby
ast = SolidRail::Parser.parse_file('contracts/token.rb')
```

### `ASTNode`

Represents a node in the Abstract Syntax Tree.

#### Properties

- `type` (Symbol) - Node type (e.g., `:class`, `:def`, `:assign`)
- `value` (Object) - Node value
- `children` (Array) - Child nodes
- `line` (Integer) - Source line number
- `column` (Integer) - Source column number

#### Methods

##### `to_s`

Returns a string representation of the AST node.

**Returns:**

- `String` - String representation

**Example:**

```ruby
ast = SolidRail::Parser.parse(ruby_code)
puts ast.to_s
```

##### `find_nodes(type)`

Finds all nodes of a specific type in the AST.

**Parameters:**

- `type` (Symbol) - Node type to search for

**Returns:**

- `Array<ASTNode>` - Array of matching nodes

**Example:**

```ruby
ast = SolidRail::Parser.parse(ruby_code)
class_nodes = ast.find_nodes(:class)
method_nodes = ast.find_nodes(:def)
```

## 🔄 Mapper API

### `SolidRail::Mapper`

Provides mapping logic between Ruby and Solidity types and syntax.

#### Methods

##### `map_type(ruby_type)`

Maps Ruby types to Solidity types.

**Parameters:**

- `ruby_type` (Class) - Ruby type class

**Returns:**

- `String` - Corresponding Solidity type

**Example:**

```ruby
SolidRail::Mapper.map_type(Integer)     # => "uint256"
SolidRail::Mapper.map_type(String)      # => "string memory"
SolidRail::Mapper.map_type(Array)       # => "uint256[]"
SolidRail::Mapper.map_type(Hash)        # => "mapping(uint256 => uint256)"
SolidRail::Mapper.map_type(Symbol)      # => "string memory"
SolidRail::Mapper.map_type(Boolean)     # => "bool"
```

##### `map_visibility(ruby_visibility)`

Maps Ruby method visibility to Solidity function visibility.

**Parameters:**

- `ruby_visibility` (Symbol) - Ruby visibility (`:public`, `:private`, `:protected`)

**Returns:**

- `String` - Corresponding Solidity visibility

**Example:**

```ruby
SolidRail::Mapper.map_visibility(:public)    # => "public"
SolidRail::Mapper.map_visibility(:private)   # => "private"
SolidRail::Mapper.map_visibility(:protected) # => "internal"
```

##### `map_function_type(ruby_type)`

Maps Ruby function types to Solidity function types.

**Parameters:**

- `ruby_type` (Symbol) - Ruby function type (`:view`, `:pure`, `:external`)

**Returns:**

- `String` - Corresponding Solidity function type

**Example:**

```ruby
SolidRail::Mapper.map_function_type(:view)     # => "view"
SolidRail::Mapper.map_function_type(:pure)     # => "pure"
SolidRail::Mapper.map_function_type(:external) # => "external"
```

## 🏭 Generator API

### `SolidRail::Generator`

Responsible for generating Solidity code from the Ruby AST.

#### Methods

##### `generate_solidity(ast, options = {})`

Generates Solidity code from an AST.

**Parameters:**

- `ast` (ASTNode) - Root AST node
- `options` (Hash) - Generation options

**Returns:**

- `String` - Generated Solidity code

**Example:**

```ruby
ast = SolidRail::Parser.parse(ruby_code)
solidity_code = SolidRail::Generator.generate_solidity(ast)
puts solidity_code
```

##### `generate_contract(class_node)`

Generates a Solidity contract from a Ruby class node.

**Parameters:**

- `class_node` (ASTNode) - Class AST node

**Returns:**

- `String` - Generated contract code

**Example:**

```ruby
ast = SolidRail::Parser.parse(ruby_code)
class_node = ast.find_nodes(:class).first
contract_code = SolidRail::Generator.generate_contract(class_node)
```

##### `generate_function(def_node)`

Generates a Solidity function from a Ruby method node.

**Parameters:**

- `def_node` (ASTNode) - Method AST node

**Returns:**

- `String` - Generated function code

**Example:**

```ruby
ast = SolidRail::Parser.parse(ruby_code)
method_node = ast.find_nodes(:def).first
function_code = SolidRail::Generator.generate_function(method_node)
```

## ⚡ Optimizer API

### `SolidRail::Optimizer`

Contains logic for optimizing generated Solidity code.

#### Methods

##### `optimize(solidity_code, options = {})`

Optimizes Solidity code for gas efficiency and security.

**Parameters:**

- `solidity_code` (String) - Solidity code to optimize
- `options` (Hash) - Optimization options

**Returns:**

- `String` - Optimized Solidity code

**Example:**

```ruby
solidity_code = SolidRail::Generator.generate_solidity(ast)
optimized_code = SolidRail::Optimizer.optimize(solidity_code, {
  gas_optimization: true,
  security_optimization: true
})
```

##### `apply_gas_optimizations(solidity_code)`

Applies gas optimization techniques.

**Parameters:**

- `solidity_code` (String) - Solidity code to optimize

**Returns:**

- `String` - Gas-optimized code

**Example:**

```ruby
optimized_code = SolidRail::Optimizer.apply_gas_optimizations(solidity_code)
```

##### `apply_security_optimizations(solidity_code)`

Applies security optimization techniques.

**Parameters:**

- `solidity_code` (String) - Solidity code to optimize

**Returns:**

- `String` - Security-optimized code

**Example:**

```ruby
secure_code = SolidRail::Optimizer.apply_security_optimizations(solidity_code)
```

## ✅ Validator API

### `SolidRail::Validator`

Provides validation for both Ruby source code and generated Solidity code.

#### Methods

##### `validate_ruby_code(ruby_code)`

Validates Ruby source code for smart contract patterns and security.

**Parameters:**

- `ruby_code` (String) - Ruby source code to validate

**Returns:**

- `Hash` - Validation results with warnings and errors

**Example:**

```ruby
validation = SolidRail::Validator.validate_ruby_code(ruby_code)
if validation[:errors].any?
  puts "Validation errors: #{validation[:errors]}"
end
if validation[:warnings].any?
  puts "Validation warnings: #{validation[:warnings]}"
end
```

##### `validate_solidity_code(solidity_code)`

Validates generated Solidity code for syntax and security patterns.

**Parameters:**

- `solidity_code` (String) - Solidity code to validate

**Returns:**

- `Hash` - Validation results with warnings and errors

**Example:**

```ruby
validation = SolidRail::Validator.validate_solidity_code(solidity_code)
if validation[:errors].any?
  puts "Solidity validation errors: #{validation[:errors]}"
end
```

##### `check_security_patterns(code, language = :ruby)`

Checks for security patterns in code.

**Parameters:**

- `code` (String) - Code to check
- `language` (Symbol) - Language (`:ruby` or `:solidity`)

**Returns:**

- `Array<String>` - Array of security warnings

**Example:**

```ruby
security_warnings = SolidRail::Validator.check_security_patterns(ruby_code, :ruby)
security_warnings.each { |warning| puts "Security warning: #{warning}" }
```

## 🔧 Compiler API

### `SolidRail::Compiler`

Orchestrates the entire transpilation process.

#### Methods

##### `compile(ruby_code, options = {})`

Compiles Ruby code to Solidity.

**Parameters:**

- `ruby_code` (String) - Ruby source code
- `options` (Hash) - Compilation options

**Returns:**

- `Hash` - Compilation results

**Example:**

```ruby
result = SolidRail::Compiler.compile(ruby_code, {
  optimization_enabled: true,
  gas_optimization: true,
  security_checks: true
})

if result[:success]
  puts "Generated Solidity:"
  puts result[:solidity_code]
else
  puts "Compilation errors: #{result[:errors]}"
end
```

##### `compile_file(file_path, options = {})`

Compiles a Ruby file to Solidity.

**Parameters:**

- `file_path` (String) - Path to Ruby file
- `options` (Hash) - Compilation options

**Returns:**

- `Hash` - Compilation results

**Example:**

```ruby
result = SolidRail::Compiler.compile_file('contracts/token.rb')
if result[:success]
  File.write('contracts/Token.sol', result[:solidity_code])
end
```

##### `compile_directory(directory_path, options = {})`

Compiles all Ruby files in a directory to Solidity.

**Parameters:**

- `directory_path` (String) - Path to directory
- `options` (Hash) - Compilation options

**Returns:**

- `Hash` - Compilation results for all files

**Example:**

```ruby
results = SolidRail::Compiler.compile_directory('contracts/')
results.each do |file_path, result|
  if result[:success]
    puts "✓ Compiled #{file_path}"
  else
    puts "✗ Failed to compile #{file_path}: #{result[:errors]}"
  end
end
```

## ⚙️ Configuration

### `SolidRail::Configuration`

Configuration class for SolidRail settings.

#### Properties

- `solidity_version` (String) - Target Solidity version (default: "0.8.30")
- `optimization_enabled` (Boolean) - Enable optimizations (default: true)
- `gas_optimization` (Boolean) - Enable gas optimization (default: true)
- `security_checks` (Boolean) - Enable security checks (default: true)
- `output_format` (String) - Output format ("solidity", "ast", "json") (default: "solidity")

#### Methods

##### `configure(&block)`

Configures SolidRail settings.

**Parameters:**

- `block` (Proc) - Configuration block

**Example:**

```ruby
SolidRail.configure do |config|
  config.solidity_version = '0.8.30'
  config.optimization_enabled = true
  config.gas_optimization = true
  config.security_checks = true
  config.output_format = 'solidity'
end
```

##### `reset`

Resets configuration to default values.

**Example:**

```ruby
SolidRail::Configuration.reset
```

## ⚠️ Error Classes

### `SolidRail::Error`

Base error class for all SolidRail errors.

### `SolidRail::ParseError`

Raised when parsing fails.

**Example:**

```ruby
begin
  ast = SolidRail::Parser.parse(invalid_ruby_code)
rescue SolidRail::ParseError => e
  puts "Parse error: #{e.message}"
end
```

### `SolidRail::CompilationError`

Raised when compilation fails.

**Example:**

```ruby
begin
  result = SolidRail::Compiler.compile(ruby_code)
rescue SolidRail::CompilationError => e
  puts "Compilation error: #{e.message}"
end
```

### `SolidRail::ValidationError`

Raised when validation fails.

**Example:**

```ruby
begin
  validation = SolidRail::Validator.validate_ruby_code(ruby_code)
  if validation[:errors].any?
    raise SolidRail::ValidationError, validation[:errors].join(', ')
  end
rescue SolidRail::ValidationError => e
  puts "Validation error: #{e.message}"
end
```

## 🖥️ CLI Reference

### Command Line Interface

SolidRail provides a command-line interface for easy usage.

#### `solidrail compile`

Compiles Ruby code to Solidity.

**Usage:**

```bash
solidrail compile <file> [options]
```

**Options:**

- `--output, -o` - Output file path
- `--optimize, -O` - Enable optimizations
- `--gas-optimize` - Enable gas optimization
- `--security-checks` - Enable security checks
- `--format` - Output format (solidity, ast, json)

**Example:**

```bash
solidrail compile contracts/token.rb -o contracts/Token.sol --optimize
```

#### `solidrail parse`

Parses Ruby code and displays the AST.

**Usage:**

```bash
solidrail parse <file> [options]
```

**Options:**

- `--format` - Output format (tree, json, yaml)

**Example:**

```bash
solidrail parse contracts/token.rb --format json
```

#### `solidrail validate`

Validates Ruby code for smart contract patterns.

**Usage:**

```bash
solidrail validate <file> [options]
```

**Options:**

- `--security-only` - Only check security patterns
- `--verbose, -v` - Verbose output

**Example:**

```bash
solidrail validate contracts/token.rb --security-only
```

#### `solidrail version`

Displays SolidRail version information.

**Usage:**

```bash
solidrail version
```

**Example:**

```bash
$ solidrail version
SolidRail v0.1.0
Ruby to Solidity Transpiler
```

## 🎯 Type System

### Ruby to Solidity Type Mappings

| Ruby Type | Solidity Type                 | Description              | Example                                      |
| --------- | ----------------------------- | ------------------------ | -------------------------------------------- |
| `Integer` | `uint256`                     | Unsigned 256-bit integer | `1000` → `uint256`                           |
| `Float`   | `uint256`                     | Converted to integer     | `3.14` → `uint256`                           |
| `String`  | `string memory`               | Dynamic string           | `"Hello"` → `string memory`                  |
| `Symbol`  | `string memory`               | Converted to string      | `:transfer` → `string memory`                |
| `Array`   | `uint256[]`                   | Dynamic array            | `[1, 2, 3]` → `uint256[]`                    |
| `Hash`    | `mapping(uint256 => uint256)` | Key-value mapping        | `{1 => 100}` → `mapping(uint256 => uint256)` |
| `Boolean` | `bool`                        | Boolean value            | `true` → `bool`                              |
| `Nil`     | Not supported                 | Use explicit checks      | `nil` → Not supported                        |

### Type Conversion Examples

```ruby
# Ruby types
@total_supply = 1_000_000
@name = "MyToken"
@decimals = 18
@owner = msg.sender
@balances = {}
@paused = false

# Translates to Solidity:
uint256 public totalSupply = 1000000;
string public name = "MyToken";
uint8 public decimals = 18;
address public owner = msg.sender;
mapping(address => uint256) public balances;
bool public paused = false;
```

## 📝 Examples

### Basic Token Contract

**Ruby Input:**

```ruby
class Token < ERC20
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @total_supply = 1_000_000
    @balances = {}
    @owner = msg.sender
  end

  def transfer(to, amount)
    require(to != address(0), "Transfer to zero address")
    require(@balances[msg.sender] >= amount, "Insufficient balance")

    @balances[msg.sender] -= amount
    @balances[to] += amount
    emit Transfer(msg.sender, to, amount)
  end

  def mint(to, amount)
    require(msg.sender == @owner, "Only owner can mint")
    @total_supply += amount
    @balances[to] += amount
    emit Transfer(address(0), to, amount)
  end
end
```

**Generated Solidity:**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 1000000;
        owner = msg.sender;
    }

    function transfer(address to, uint256 amount) public {
        require(to != address(0), "Transfer to zero address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        totalSupply += amount;
        balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }
}
```

### Advanced Contract with Events and Modifiers

**Ruby Input:**

```ruby
class AdvancedToken < ERC20
  event Minted(to: Address, amount: Uint256)
  event Burned(from: Address, amount: Uint256)
  event Paused(account: Address)
  event Unpaused(account: Address)

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @total_supply = 0
    @balances = {}
    @owner = msg.sender
    @paused = false
  end

  def only_owner
    require(msg.sender == @owner, "Only owner can call this function")
  end

  def when_not_paused
    require(!@paused, "Contract is paused")
  end

  def transfer(to, amount)
    when_not_paused
    require(to != address(0), "Transfer to zero address")
    require(@balances[msg.sender] >= amount, "Insufficient balance")

    @balances[msg.sender] -= amount
    @balances[to] += amount
    emit Transfer(msg.sender, to, amount)
  end

  def mint(to, amount)
    only_owner
    when_not_paused
    @total_supply += amount
    @balances[to] += amount
    emit Minted(to, amount)
    emit Transfer(address(0), to, amount)
  end

  def burn(amount)
    when_not_paused
    require(@balances[msg.sender] >= amount, "Insufficient balance")
    @balances[msg.sender] -= amount
    @total_supply -= amount
    emit Burned(msg.sender, amount)
    emit Transfer(msg.sender, address(0), amount)
  end

  def pause
    only_owner
    @paused = true
    emit Paused(msg.sender)
  end

  def unpause
    only_owner
    @paused = false
    emit Unpaused(msg.sender)
  end
end
```

**Generated Solidity:**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AdvancedToken is ERC20 {
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event Paused(address indexed account);
    event Unpaused(address indexed account);

    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    address public owner;
    bool public paused;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        totalSupply = 0;
        owner = msg.sender;
        paused = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function transfer(address to, uint256 amount) public whenNotPaused {
        require(to != address(0), "Transfer to zero address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function mint(address to, uint256 amount) public onlyOwner whenNotPaused {
        totalSupply += amount;
        balances[to] += amount;
        emit Minted(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) public whenNotPaused {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burned(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }
}
```

## 🔗 Additional Resources

- [Getting Started Guide](getting-started.md)
- [Language Reference](language-reference.md)
- [Best Practices](best-practices.md)
- [GitHub Repository](https://github.com/rfdlp/solid-rail)
- [Issue Tracker](https://github.com/rfdlp/solid-rail/issues)

---

This API reference provides comprehensive documentation for all SolidRail components and functionality. For more examples and advanced usage patterns, check out the [examples directory](https://github.com/rfdlp/solid-rail/tree/main/examples) and other documentation guides.
