// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

contract Auction{
    uint private duration;
    uint private starting;
    uint public deadline;

    address public highestBidder;
    uint public highestBid;

    event BidPlaced(address indexed bidder, uint amount);

    constructor() {
        duration = 300;
        starting = block.timestamp;
        deadline = starting + duration;
    }

    function bid() public payable {
        require(block.timestamp < deadline, "Auction ended");
        require(msg.value > highestBid, "Bid too low");

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, msg.value);
    }

    function winner() public view returns( address ){
        require(block.timestamp >= deadline , "time remaining");
        return (highestBidder) ;
    }
}