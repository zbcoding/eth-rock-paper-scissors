// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
 
import "../interfaces/IERC20.sol";

contract RockPaperScissors {
  mapping (address => uint8) choice; //map address to 1,2, or 3
  mapping (address => uint256) amount;
  //1 = rock 2 = paper 3 = scissors
  address address1;
  address address2;

  using SafeMath for uint256;
  

	//constructor(uint256 total) public { for older solidity
  constructor() {
  //todo: add set owner so that owner can withdraw fees generated to their address

  }

  function deposit() payable public {
    //allow deposit
  }

  function wager(uint256 _amount, uint8 _choice) payable external {
    deposit();
    //todo: ensure user deposits _amount into the contract
    amount[msg.sender] = _amount;
    choice[msg.sender] = _choice;
    if (address1 && address2) {
        address1 = address2;
        address2 = msg.sender;
    }
    else {
      address1 = msg.sender;
      address2 = msg.sender;
    }
    }

  function callGame() external {
    uint8 a1 = choice(address1);
    uint8 a2 = choice(address2);
    if (a1 == a2) {
//todo: add logic of rock paper scissors winning/ties
    }

    //implement pay function to pay an amount to an address
    //pay back amounts deposited using mapping count variable if ties
    //pay 99% (1% fee) of both amounts to winner by summing the amounts giving by mapping
  }
    


}

library SafeMath {
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
