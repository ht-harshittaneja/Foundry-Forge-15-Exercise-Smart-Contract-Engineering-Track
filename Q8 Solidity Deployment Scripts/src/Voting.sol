// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Voting {
    address public owner ;
    uint256 id = 1;
    mapping(uint256 => string) public proposals ;
    mapping(address => uint256)  private votingDatabase ;
    mapping(uint256 => uint256) public voteCount;

    constructor(){
        owner = msg.sender;

        proposals[id] = "XYZ";
        id = id+1;
        proposals[id] = "BJP";
        id= id+1;
        proposals[id] = "ABC";
        id = id+1 ;
    }

    function addProposal(string calldata _symbol) public {
        proposals[id] = _symbol;
        id++;
    }

    function digitalVotingBooth(uint256 _no) public {
        require(votingDatabase[msg.sender] == 0, "Already voted");
        require(_no>=1 && _no<id ,"NOT A VALID CANDIDATE") ;
        votingDatabase[msg.sender] = _no ;
        voteCount[_no] +=1 ;
    }
}