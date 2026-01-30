// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.20;

contract Ownable{
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(){
        owner = msg.sender ;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    function transferOwnership(address _newOwner) public virtual onlyOwner{
       require(_newOwner != address(0) , "New owner address should not be 0");
        emit OwnershipTransferred(owner , _newOwner);
        owner = _newOwner;
    }
}