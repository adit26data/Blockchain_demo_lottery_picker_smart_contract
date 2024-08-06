// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
contract Lottery{
    //creating the owner
    address public owner;
    //creating the list of participants
    address payable[] public players;
    //creating a lottery winning id and the map for the winning id
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;
    constructor() {
        //default constructor
        owner = msg.sender;
        lotteryId = 1;
    }
    //getting the address of the winner
    function getWinnerByLottery(uint lottery) public view returns (address payable){
        return lotteryHistory[lottery];
    }
    //getting the lottery balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    //getting the players list
    function getPlayers() public view returns ( address payable[] memory){
        return players;
    }
    //public function to enter the lottery pool
    function enter() public payable{
        //fee check
        require(msg.value > .01 ether);
        //address of the player entering the lottery
        players.push(payable(msg.sender));
    }
    //random number generator
    function getRandomNumber() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }
    //random picker function
    function pickWinner() public onlyOwner{
       //function call here
        uint index = getRandomNumber() % players.length;
        //mapping the added balance to the player account
        players[index].transfer(address(this).balance);
        lotteryHistory[lotteryId] = players[index];
        lotteryId++; 
        //reset the contract state
        players = new address payable[](0);
    }
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }}