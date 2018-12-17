pragma solidity ^0.4.24;

contract MyToken {
    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor() public {
        balanceOf[msg.sender] = 1000000;    // Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] -= _value;    // Subtract from the sender
        balanceOf[_to] += _value;           // Add the same to the recipient
    }
}

/*

$ ganache-cli

-------------

$ truffle console 

truffle> compile
truffle> migrate --reset

truffle> var mt = MyToken.at(MyToken.address)

truffle> mt.balanceOf(web3.eth.accounts[0])
truffle> mt.balanceOf(web3.eth.accounts[1])
truffle> mt.transfer(web3.eth.accounts[1], 1000)
truffle> mt.transfer(web3.eth.account[2], 100000000000)
truffle> mt.balanceOf(web3.eth.accounts[0])
BigNumber {
  s: 1,
  e: 77,
  c:
   [ 11579208,
     92373161954235,
     70985008687907,
     85326998466564,
     5640394574840,
     7913130638936 ] }

This is a negative overflow, the current balance is less than 0

*/







*/