pragma solidity ^0.4.24;

import "../library/Owned.sol";

contract MyToken is Owned {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    bool locked;
    modifier noReentrancy() {
        require(!locked, "Item is locked");
        locked = true;
        _;
        locked = false;
    }

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value); // indexed make an item searchable

    // This generates a public event on the blockchain that will notify clients
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
        name = tokenName;                                       // Set the name for display purposes
        symbol = tokenSymbol;                                   // Set the symbol for display purposes
    }
 

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint256 _value) noReentrancy internal { 
        // Prevent transfer to 0x0 address.
        require(_to != 0x0);
        // Check if the sender has enough         
        require(balanceOf[_from] >= _value, "Not enough sender's balance to transfer");
        // Check for overflows 
        require(balanceOf[_to] + _value >= balanceOf[_to], "Causes balance overflow");
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];   
        // Subtract from the sender
        balanceOf[_from] -= _value; 
        // Add the same amount to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value); // emit Event
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     * @param _to The address of the recipient
     * @param _value the amount to send
     *
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        success = true; 
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     * 
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     *
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender],"Amount request is not covered by remaining allowance");  // Check allowance if requested amount is covered
        allowance[_from][msg.sender] -= _value;   // reduce the allowance
        _transfer(_from, _to, _value);
    }

    /**
     * Set allowance for other address
     *
     * Allows `spender` to spend no more than `_value` tokens on your behalf
     * 
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     *
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); // emit
        return true;
    } 

    function mintToken(address target, uint256 mintedAmount) public onlyOwner {
        balanceOf[target] += mintedAmount * 10 ** uint256(decimals);
        totalSupply += mintedAmount * 10 ** uint256(decimals);
        emit Transfer(0, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }

    function () public payable {}
} 