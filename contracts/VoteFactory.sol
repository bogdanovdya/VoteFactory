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
        State voteState;
        string[] answers;
        address[] users;
        mapping(uint => uint) userToAnswer;
    }
    
    Vote[] public votes;
    mapping (uint => address) voteToOwner;

    function createVote(string _question) public {
        uint voteId = votes.push(Vote(_question, State.Inital, new string[](0),  new address[](0))) - 1;
        voteToOwner[voteId] = msg.sender;
    }
    
    function addAnswer(uint _voteId, string _answer) public voteStateInital(_voteId) ownerOfVote(_voteId) {
        votes[_voteId].answers.push(_answer);
    }

    function startVote(uint _voteId) public voteStateInital(_voteId) ownerOfVote(_voteId) {
        require(votes[_voteId].answers.length >= 2);
        votes[_voteId].voteState = State.Started;
    }

    function stopVote(uint _voteId) public voteStateStarted(_voteId) ownerOfVote(_voteId) {
        votes[_voteId].voteState = State.Stopped;
    }
            
    function cast(uint256 _voteId, uint256 _answerId) public voteStateStarted(_voteId) {
        require(_answerId < votes[_voteId].answers.length);
        for (uint i = 0; i < votes[_voteId].users.length; i++) {
            if (votes[_voteId].users[i] == msg.sender) {
                votes[_voteId].userToAnswer[i] = _answerId;
                break;
            }
        }

        uint newUser = votes[_voteId].users.push(msg.sender) - 1;
        votes[_voteId].userToAnswer[newUser] = _answerId;
    }

    function results(uint _voteId) public view voteStateStopped(_voteId) returns(string) {
        uint[] memory result = new uint[](votes[_voteId].answers.length);
        
        for (uint i = 0; i < votes[_voteId].users.length; i++){
            result[votes[_voteId].userToAnswer[i]]++;
        }

        uint winnerId = 0;
        for (i = 0; i < result.length; i++){
            if (result[i] > result[winnerId]){
                winnerId = i;
            }
        }

        return votes[_voteId].answers[winnerId];
    }

}