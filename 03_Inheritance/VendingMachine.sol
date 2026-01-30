// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IsodaPrice.sol";
import "./Ownable.sol";

/**
 * @title VendingMachine
 * @dev A simple contract to simulate a vending machine that sells "Digital Sodas".
 */
contract VendingMachine is Ownable {

    // The number of sodas currently in the machine.
    uint public sodaInventory;

    IsodaPrice public sodaAddress;


    event SodaPurchase(address buyer , uint sodaCount);


    mapping (address => uint) public sodaCount ;

    // Set the owner and initial inventory when the contract is deployed.
    constructor(address _sodaAddress) {
        sodaInventory = 100; // Start with 100 sodas.
        sodaAddress = IsodaPrice(_sodaAddress);
    }

    /**
     * @dev Allows anyone to buy a soda by sending exactly 0.01 ETH.
     */
    function buySoda() public payable {
        // Check that there are sodas in stock.
        require(sodaInventory > 0, "Sorry, out of stock!");

        // Check that the user paid the exact price.
        require(
            msg.value == sodaAddress.getPrice(),
            "You must pay exactly 1 ETH per soda."
        );
          



        // If checks pass, decrease the inventory.
        sodaInventory = sodaInventory - 1;
        // increment count
    sodaCount[msg.sender] += 1;

    // ✅ emit the UPDATED soda count for this buyer
    emit SodaPurchase(msg.sender, sodaCount[msg.sender]);
    }

    /**
     * @dev Allows the owner to see the current Ether balance of the machine.
     */
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    /**
     * @dev Allows the owner to restock the machine.
     * @param _amount The number of sodas to add to the inventory.
     */
    function restock(uint _amount) public onlyOwner {
        sodaInventory = sodaInventory + _amount;
    }

    /**
     * @dev Allows the owner to withdraw all collected profits.
     */
    function withdrawProfits() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No profits to withdraw.");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "ETH transfer failed");
    }
}
