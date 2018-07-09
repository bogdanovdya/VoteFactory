pragma solidity ^0.4.19;

contract VoteFactory {
    
    address owner;
    
    struct Vote {
        string question;
        string[] answers;
    }
    
    Vote[] public votes;
    mapping (uint => address) voteToOwner;

    constructor() public {
        owner = msg.sender;
    }

    function createVote(string _question) public {
        uint voteId = votes.push(Vote(_question, new string[](0))) - 1;
        voteToOwner[voteId] = msg.sender;
    }
    
    function addAnswer(uint _voteId, string _answer) public {
        require(voteToOwner[_voteId] == msg.sender);
        votes[_voteId].answers.push(_answer);
    }
    
}