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

}