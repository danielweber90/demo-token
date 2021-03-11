// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

import "./SafeMath.sol";
import "./IERC20.sol";

contract ERC20 is IERC20 {
    
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    
    uint256 _totalSupply;
    
    mapping (address => uint256) balances;
    mapping (address => mapping(address => uint256)) allowed;
    
    using SafeMath for uint256;
    
    constructor(string memory _name, string memory _symbol, uint256 total) {
        name = _name;
        symbol = _symbol;
        _totalSupply = total;
    
        balances[msg.sender] = total;
        
        emit Transfer(address(0), msg.sender, total);
    }
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address tokenOwner) public view override returns (uint256 balance) {
        return balances[tokenOwner];
    }
    function allowance(address tokenOwner, address spender) public view override returns (uint256 remaining) {
        return allowed[tokenOwner][spender];
    }
    function approve(address spender, uint256 tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    function transfer(address to, uint256 tokens) public override returns (bool success) {
        balances[msg.sender] = balances[msg.sender].safeSub(tokens);
        balances[to] = balances[to].safeAdd(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        balances[from] = balances[from].safeSub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].safeSub(tokens);
        balances[to] = balances[to].safeAdd(tokens);
            
    	emit Transfer(from, to, tokens);
        return true;
    }
}
