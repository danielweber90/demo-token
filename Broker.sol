// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

import "./SafeMath.sol";
import "./ERC20.sol";

contract Broker {

    using SafeMath for uint256;
    
    IERC20 public token;

    event Bought(uint256 amount, uint256 costs);
    event Sold(uint256 amount, uint256 revenue);
    
    uint256 public price;
    
    address _owner;

    constructor(uint256 initialPrice) {
        token = new DemoToken("DemoToken", "DMT", 100 ether);
        price = initialPrice;
        _owner = msg.sender;
    }
    
    function changePrice(uint256 newPrice) public {
        require(msg.sender == address(this), "Only contract owner can change price");
        price = newPrice;
    }
    
    function buy() payable public {
        uint256 amountTobuy = msg.value.safeDiv(price);
        uint256 brokerBalance = token.balanceOf(address(this));
        require(amountTobuy > 0, "You need to send some Ether");
        require(amountTobuy <= brokerBalance, "Not enough tokens in the reserve");
        token.transfer(msg.sender, amountTobuy);
        emit Bought(amountTobuy, msg.value);
    }
    
    function sell(uint256 amount) public {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        uint256 revenue = amount.safeMul(price);
        token.transferFrom(msg.sender, address(this), amount);
        msg.sender.transfer(revenue);
        emit Sold(amount, revenue);
    }

}
