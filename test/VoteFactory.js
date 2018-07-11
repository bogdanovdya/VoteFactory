const BigNumber = web3.BigNumber;
var ethUtil = require('ethereumjs-util')
var Tx = require('ethereumjs-tx');
const expect = require('chai').expect;
const should = require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(web3.BigNumber))
    .should();

import expectThrow from './helpers/expectThrow.js';

var VoteFactory = artifacts.require("./VoteFactory.sol");

contract('VoteFactory', function(accounts) {
    var voteFactory;

    const owner = accounts[0];
    const creator = accounts[1];
    const creator1 = accounts[3];
    const user = accounts[2];

    const question0 = "Question 0";
    const question1 = "Question 1"
    const answer0 = "Answer 0";
    const answer1 = "Answer 1";

    beforeEach('setup contract for each test', async function () {
        voteFactory = await VoteFactory.new({from: owner});
    });



    //CREATE VOTE AND ADD ANSWER TESTS

    it('should create vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        var vote = await voteFactory.votes(0);

        vote[0].should.be.equal(question0);
    });

    it('should add answer by creator', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.addAnswer(0, answer0, {from: creator});
    });

    it('should not add answer by user', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.addAnswer(0, answer0, {from: user}));
    });

    it('should not add answer by owner', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.addAnswer(0, answer0, {from: owner}));
    });

    it('should not add answer by another creator', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.createVote(question1, {from: creator1});
        await expectThrow(voteFactory.addAnswer(0, answer0, {from: creator1}));
        await expectThrow(voteFactory.addAnswer(1, answer1, {from: creator}));
    });

    it('should not add answer to notexist vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.addAnswer(1, answer0, {from: creator}));
    });

    //END CREATE VOTE AND ADD ANSWER TEST

    

    //START'N'STOP VOTE TESTS
    
    it('should start vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
    });

    it('should stop vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await voteFactory.stopVote(0, {from: creator});
    });
 
    it('should not add answer to started vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await expectThrow(voteFactory.addAnswer(0, answer0, {from: creator}));
    });

    it('should not add answer to stopped vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await voteFactory.stopVote(0, {from: creator});
        await expectThrow(voteFactory.addAnswer(0, answer0, {from: creator}));
    });

    it('should not start vote by user', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.startVote(0, {from: user}));
    });

    it('should not stop vote by user', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await expectThrow(voteFactory.stopVote(0, {from: user}));
    });

    it('should not start vote by owner', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.startVote(0, {from: owner}));
    });

    it('should not stop vote by owner', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await expectThrow(voteFactory.stopVote(0, {from: owner}));
    });

    it('should not start notexist vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.startVote(1, {from: creator}));
    });

    it('should not stop notexist vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await expectThrow(voteFactory.stopVote(1, {from: creator}));
    });
    
    it('should not stop notstarted vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.stopVote(0, {from: creator}));
    });

    it('should not start stopped vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.startVote(0, {from: creator});
        await voteFactory.stopVote(0, {from: creator});
        await expectThrow(voteFactory.startVote(0, {from: creator}));
    });

    it('should not start vote by another creator', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.createVote(question1, {from: creator1});
        await expectThrow(voteFactory.startVote(0, {from: creator1}));
        await expectThrow(voteFactory.startVote(1, {from: creator}));
    });

    it('should not stop vote by another creator', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.createVote(question1, {from: creator1});
        await voteFactory.startVote(0, {from: creator});
        await voteFactory.startVote(1, {from: creator1});
        await expectThrow(voteFactory.stopVote(0, {from: creator1}));
        await expectThrow(voteFactory.stopVote(1, {from: creator}));
    });

    //END START'N'STOP VOTE TESTS

});
