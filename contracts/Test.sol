pragma solidity ^0.4.24;

import "./VoteFactory.sol";

//CONTRACT FOR IZI TESTS
contract Test is VoteFactory {

    function testAddAnswer(uint _voteId, string _answer) external constant returns(string) {
        addAnswer(_voteId, _answer);
        return votes[_voteId].answers[votes[_voteId].answers.length-1];
    }

    function testStartVote(uint _voteId) external constant returns(State) {
        startVote(_voteId);
        return votes[_voteId].voteState;
    }

    function testStopVote(uint _voteId) external constant returns(State) {
        stopVote(_voteId);
        return votes[_voteId].voteState;
    }

    function testTransferOwnership(address _newOwner) external constant returns(address) {
        transferOwnership(_newOwner);

        return owner;
    }

    function testRenounceOwnership() external constant returns (address) {
        return owner;
    }

    function testCast(uint256 _voteId, uint256 _answerId) external constant returns(string) {
        cast(_voteId, _answerId);
        for (uint i = 0; i < votes[_voteId].users.length; i++){
            if (votes[_voteId].users[i] == msg.sender){
                return votes[_voteId].answers[votes[_voteId].userToAnswer[i]];
            }
        }
    }
}
