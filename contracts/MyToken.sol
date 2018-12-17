pragma solidity ^0.4.24;

contract MyToken {
    // Puble variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value); // indexed make an item searchable

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
        name = tokenName;                                       // Set the name for display purposes
        symbol = tokenSymbol;                                   // Set the symbol for display purposes
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Not enough sender's balance to transfer"); // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to], "Causes balance overflow");   // Check for overflows
        balanceOf[msg.sender] -= _value;                      // Subtract from the sender
        balanceOf[_to] += _value;                             // Add the same to the recipient
        emit Transfer(msg.sender, _to, _value);               // emit Event
        return true;
    }
} 