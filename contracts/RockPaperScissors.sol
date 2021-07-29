// SPDX-License-Identifier: MIT
//

//this implementation has the player choices on blockchain, which could be gamed

pragma solidity ^0.8.0;
 
import "../interfaces/IERC20.sol";
import "../interfaces/SafeMath.sol";

contract RockPaperScissors {
  mapping (address => uint8) choice; //map address to 1,2, or 3
  mapping (address => uint256) amount;
  //1 = rock 2 = paper 3 = scissors
  address payable public owner;
  address payable public address1;
  address payable public address2;
  event game(address indexed _player1,
  address indexed _player2, 
  string indexed _winAddress, 
  int256 _totalAmountBet);


  using SafeMath for uint256;
  

	//constructor(uint256 total) public { for older solidity
  constructor() payable {
  //todo: add set owner so that owner can withdraw fees generated to their address
  owner = payable(msg.sender);
  }

  function deposit() payable public {
    //allow deposit
  }
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function withdraw() public onlyOwner {
    // get the amount of Ether stored in this contract
    uint256 contractAmount = address(this).balance;
    (bool success,) = owner.call{value: contractAmount}("");
    require(success, "Failed to send Ether");
  }

  function transfer(address payable _to, uint _amount) public {
    // Note that "to" is declared as payable
    (bool success,) = _to.call{value: _amount}("");
    require(success, "Failed to send Ether");
  }

  function wager(uint256 _amount, uint8 _choice) payable external {
    deposit();
    //todo: ensure user deposits _amount into the contract
    amount[msg.sender] = _amount;
    choice[msg.sender] = _choice;
    require(_choice <=3 && _choice >=1); //1, 2, or 3.
    if (address1 != address(0) && address2 != address(0)) {
        address1 = address2;
        address2 = payable(msg.sender);
    }
    else {
      address1 = payable(msg.sender);
      address2 = payable(msg.sender);
    }
    }

  function callGame() external {
    string memory winAddress;
    uint8 a1 = choice[address1];
    uint8 a2 = choice[address2];
    uint256 winAmount = 99*(amount[address1] + amount[address2])/100;
    require(amount[address1] == amount[address2], "Bet amounts do not match");
    //logic of rock paper scissors winning/ties
    if (a1 == a2) {
    winAddress = "Tie";
    //pay back both addresses' bet with each contributing to fee
    transfer(address1, (995*amount[address1])/1000);
    transfer(address2, (995*amount[address2])/1000);
    }
    if (a1==1 && a2==2) { //rock, paper
      winAddress = toAsciiString(address2);
      transfer(address2, (winAmount));
    } 
    if (a1==1 && a2==3) { //rock, scissors
      winAddress = toAsciiString(address1);
      transfer(address1, (winAmount));
    } 
    if (a1==2 && a2==1) { //paper, rock
      winAddress = toAsciiString(address1);
      transfer(address1, (winAmount));
    }
    if (a1==2 && a2==3) { //paper, scissors
      winAddress = toAsciiString(address2);
      transfer(address2, (winAmount));
    }  
    if (a1==3 && a2==1) { //scissors, rock
      winAddress = toAsciiString(address2);
      transfer(address2, (winAmount));
    } 
    if (a1==3 && a2==2) { //scissors, paper
      winAddress = toAsciiString(address1);
      transfer(address1, (winAmount));
    } 
    //event
    uint256 totalAmount = amount[address1] + amount[address2];
    emit game(address1, address2, winAddress, int256(totalAmount));
  }
    
  function toAsciiString(address x) internal pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);            
    }
    return string(s);
  }

  function char(bytes1 b) internal pure returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    else return bytes1(uint8(b) + 0x57);
  }

}


