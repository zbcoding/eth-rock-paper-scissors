// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
 
import "../interfaces/IERC20.sol";

contract ERC20Basic is IERC20 {
 
  string public constant name = "ERC20TokenExample";
  string public constant symbol = "E2T";
  uint8 public constant decimals = 8;


  //event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
  //event Transfer(address indexed from, address indexed to, uint tokens);
 
 
  mapping(address => uint256) balances;

  mapping(address => mapping (address => uint256)) allowed;

  uint256 totalSupply_;

  using SafeMath for uint256;

	//constructor(uint256 total) public { for older solidity
  constructor(uint256 total) {
    totalSupply_ = total;
    balances[msg.sender] = totalSupply_;
  }
 
  function totalSupply() public override view returns (uint256) {
  return totalSupply_;
  }
 
  function balanceOf(address tokenOwner) public override view returns (uint256) {
      return balances[tokenOwner];
  }

  function transfer(address receiver, uint256 numTokens) public override returns (bool) {
    require(numTokens <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(numTokens);
    balances[receiver] = balances[receiver].add(numTokens);
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
	}
 
  function approve(address delegate, uint256 numTokens) public override returns (bool) {
    allowed[msg.sender][delegate] = numTokens;
    emit Approval(msg.sender, delegate, numTokens);
    return true;
  }
 
  function allowance(address owner, address delegate) public override view returns (uint) {
    return allowed[owner][delegate];
  }
 
	/*When an ERC20 token holder interacts with another contract 
	using the token, 
	two transactions are required:
	The token holder calls approve to set an allowance of tokens 
	that the contract can use. 
	(assuming an OpenZeppelin ERC20 implementation 
	can use increaseAllowance 15)
	The token holder calls the contract to perform an action 
	and the contract can transferFrom an amount of tokens 
	within the set allowance.
	*/

  function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
    require(numTokens <= balances[owner]);
    require(numTokens <= allowed[owner][msg.sender]);
    balances[owner] = balances[owner].sub(numTokens);
    allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
    balances[buyer] = balances[buyer].add(numTokens);
    emit Transfer(owner, buyer, numTokens);
    return true;
  }

	//a funny custom function that sends 1 token to the burn address 0x000...
	function burnOneToken() external {
		transfer(0x0000000000000000000000000000000000000000, 1e8);
		//1e8, token has 8 decimals
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
