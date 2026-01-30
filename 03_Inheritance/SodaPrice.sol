// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./IsodaPrice.sol";
import "./Ownable.sol";

contract SodaPrice is IsodaPrice , Ownable{
    uint public price;

    constructor(){
        price = 1 ether;
    }
    function getPrice() external view returns(uint){
        return price;
    }

    function setPrice(uint _price)public {
        require(msg.sender == owner , "Only owner can set price");
        price = _price;
    
    }
}