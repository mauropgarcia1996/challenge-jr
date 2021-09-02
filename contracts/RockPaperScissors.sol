// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract RockPaperScissors {
    address payable private bob;
    address payable private alice;
    
    uint8 rock;
    uint8 paper;
    uint8 scissors;
    
    uint256 fee;
    
    mapping(address => uint8) public choices;
    
    constructor() {
        rock = 1;
        paper = 2;
        scissors = 3;
        fee = 1 ether;
    }
    
    function enroll() external payable canJoin {
        require(msg.value == fee);
        
        if (bob == address(0)) {
            bob = payable(msg.sender);
        } else {
            alice = payable(msg.sender);
        }
    }
    
    function play(uint8 move) external hasJoined {
        require(move == rock || move == paper || move == scissors);
        choices[msg.sender] = move;
    }
    
    function game() external payable hasJoined hasPlayed {
        
        if (checkWinner() == address(0)) {
            bob.transfer(fee);
            alice.transfer(fee);
        } else if (checkWinner() == bob) {
            bob.transfer(address(this).balance);
        } else if (checkWinner() == alice) {
            alice.transfer(address(this).balance);
        }
        
        // We reset the "game"
        
        bob = payable(address(0));
        alice = payable(address(0));
        
        delete choices[bob];
        delete choices[alice];
        
    }
    
    
    // Helpers
    
    modifier canJoin {
        require(bob == address(0) || alice == address(0), 'NO ROOM LEFT');
        _;
    }
    
    modifier hasJoined {
        require(msg.sender == bob || msg.sender == alice, 'YOU MUST ENROLL FIRST');
        _;
    }
    
    modifier hasPlayed {
        require(choices[msg.sender] == rock || choices[msg.sender] == paper || choices[msg.sender] == scissors, 'YOU NEED TO PLAY FIRST');
        _;
    }
    
    function checkWinner() internal view returns (address) {
        
        if (choices[bob] == choices[alice]) {
            return address(0);
        } else if (choices[bob] == paper && choices[alice] == rock) {
            return bob;
        } else if (choices[bob] == rock && choices[alice] == scissors) {
            return bob;
        } else if (choices[bob] == scissors && choices[alice] == paper) {
            return bob;
        } else {
            return alice;
        }
        
        
    }
}