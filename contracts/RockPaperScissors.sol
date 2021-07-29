// SPDX-License-Identifier: MIT
//

pragma solidity ^0.8.0;
 
import "../interfaces/IERC20.sol";
import "../interfaces/SafeMath.sol";

contract RockPaperScissors {
  //1 = rock 2 = paper 3 = scissors
  enum Choice {None, Rock, Paper, Scissors}
  bytes32 private encrypted1;
  bytes32 private encrypted2; //encrypted choice
  address payable public owner;
  address payable public address1;
  address payable public address2;
  uint256 address1bet;
  uint256 address2bet;
  //add event for wager
  //add event for choice reveal
  
  //todo: add timeout so contract refunds if bets are fully placed
  //uint256 timestart;
  //uint256 constant timeout = 30 minutes;

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

  modifier notAlreadyBet() {
        require(msg.sender != address1 && msg.sender != address2);
        _;
    }

  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function withdraw() public onlyOwner {
    // get the amount of Ether stored in this contract
    uint256 contractAmount = address(this).balance - address1bet - address2bet;
    (bool success,) = owner.call{value: contractAmount}("");
    require(success, "Failed to send Ether");
  }

  function transfer(address payable _to, uint _amount) public {
    // Note that "to" is declared as payable
    (bool success,) = _to.call{value: _amount}("");
    require(success, "Failed to send Ether");
  }

  function wager(bytes32 _encryptedChoice) public payable notAlreadyBet {
    if (address1 == address(0x0) && _encryptedChoice = 0x0) {
      address1 = msg.sender;
      address1bet = msg.value;
      encrypted1 = _encryptedChoice;
    }
    else if (address2==address(0x0) && _encryptedChoice = 0x0) {
      require(msg.value >= address1bet, "Bet must be at least as much as player 1's bet"); //bets need to at least match in amounts
      address2 = msg.sender;
      address2bet = msg.value;
      encrypted2 = _encryptedChoice;
    }
    //add event
  }

  modifier betSet() {
    require(address1 == address(0x0) ||
            address2 == address(0x0) ||
            encrypted1 == 0x0        ||
            encrypted2 == 0x0,
            "Both players have not sent in their bets");
    _;
  }
  //clear choice = Choice + random gen password e.g. Scissors-0a98s7df07asdf0789
  //front end will hash this for user when they make bet
  //to reveal later they supply this in clear text and the contract checks the hashes
  function reveal(string memory clearChoice) public betSet returns (Choice) {
    require(msg.sender == address1 || msg.sender == address2, "Address not player");
    bytes32 encryptedChoice = sha256(abi.encodePacked(clearChoice));
    if (encryptedChoice == encrypted1 && msg.sender = address1) {
      //save player1 move
    }
    else if (encryptedChoice == encrypted2 && msg.sender = address2) {
      //save player2 move
    }
    else if (msg.sender == address1) {
      //save player1 move as None
    }
    else if (msg.sender == address2) {
      //save player2 move as None
    }
    else
      //save/return None
  }

  //todo: rewrite this function
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


    reset();

  }
  

    function reset() private {
      address1 = address(0x0);
      address2 = address(0x0);
      address1bet = 0;
      address2bet = 0;
      encrypted1 = 0x0;
      encrypted2 = 0x0;
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

}//end contract


