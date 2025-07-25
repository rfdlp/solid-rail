# frozen_string_literal: true

# Example ERC20 Token Contract written in Ruby
class Token < ERC20
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @total_supply = 1_000_000
    @balances = {}
    @allowances = {}
  end

  def transfer(to, amount)
    require(balance_of(msg.sender) >= amount, 'Insufficient balance')
    @balances[msg.sender] -= amount
    @balances[to] += amount
    emit Transfer(msg.sender, to, amount)
  end

  def balance_of(owner)
    @balances[owner] || 0
  end

  def approve(spender, amount)
    @allowances[msg.sender][spender] = amount
    emit Approval(msg.sender, spender, amount)
  end

  def transfer_from(from, to, amount)
    require(balance_of(from) >= amount, 'Insufficient balance')
    require(@allowances[from][msg.sender] >= amount, 'Insufficient allowance')

    @balances[from] -= amount
    @balances[to] += amount
    @allowances[from][msg.sender] -= amount

    emit Transfer(from, to, amount)
  end
end
