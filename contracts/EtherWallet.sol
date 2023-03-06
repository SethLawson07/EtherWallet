// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {

    event Deposit(address indexed sender,uint amount);
    event Withdraw(address indexed sender,uint amount);
    event Transfer(address indexed sender,uint amount);


    address public owner;
    constructor() {
        owner=msg.sender;
    }

    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    modifier onlyOwner {
        require(msg.sender==owner,"caller is not owner");
        _;
    }

    modifier check(uint _amount) {
        uint balance = getBalance();
        require(_amount<=balance,"The amount must be less than the balance");
        _;
    }

    modifier checkAddress(address _address) {
        require(_address!=address(0),"address is null");
        _;
    }

    function withdraw(uint _amount) external onlyOwner check(_amount) {   
        (bool success,) = msg.sender.call{value : _amount}("");
        require(success,"tx failed");
        emit Withdraw(msg.sender, _amount);
    }

    function transfer(address payable _to,uint _amount) external onlyOwner check(_amount) checkAddress(_to) {
        _to.transfer(_amount);
        emit Transfer(msg.sender, _amount);
    }
    
    
}