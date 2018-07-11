pragma solidity ^0.4.24;

import "./Ownable.sol";

contract VoteFactory is Ownable {

    modifier ownerOfVote (uint _voteId) {
        require(voteToOwner[_voteId] == msg.sender);
        _;
    }

    modifier voteStateInital (uint _voteId) {
        require(votes[_voteId].voteState == State.Inital);
        _;
    }

    modifier voteStateStarted (uint _voteId) {
        require(votes[_voteId].voteState == State.Started);
        _;
    }

    modifier voteStateStopped (uint _voteId) {
        require(votes[_voteId].voteState == State.Stopped);
        _;
    }

    enum State { Inital, Started, Stopped }

    struct Vote {
        string question;
        string[] answers;
        State voteState;
    }
    
    Vote[] public votes;
    mapping (uint => address) voteToOwner;

    function createVote(string _question) public {
        uint voteId = votes.push(Vote(_question, new string[](0), State.Inital)) - 1;
        voteToOwner[voteId] = msg.sender;
    }
    
    function addAnswer(uint _voteId, string _answer) public voteStateInital(_voteId) ownerOfVote(_voteId) {
        votes[_voteId].answers.push(_answer);
    }
    
    function startVote(uint _voteId) public voteStateInital(_voteId) ownerOfVote(_voteId) {
        votes[_voteId].voteState = State.Started;
    }

    function stopVote(uint _voteId) public voteStateStarted(_voteId) ownerOfVote(_voteId) {
        votes[_voteId].voteState = State.Stopped;
    }

}