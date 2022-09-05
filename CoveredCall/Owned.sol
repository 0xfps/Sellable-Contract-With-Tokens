// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/*
* @title: Owned contract.
* @author: Anthony (fps) https://github.com/0xfps.
* @dev: 
*/

contract Owned {
    address internal contract_owner;
    event MoveOwnership(address, address);

    /*
    * @dev:
    *
    * Initializes the `contract_owner` to whoever deployed the contract.
    */
    constructor() {
        contract_owner = msg.sender;  
        emit MoveOwnership(address(0), msg.sender);
    }

    /*
    * @dev:
    *
    * Validates that `msg.sender` is the contract owner.
    */
    modifier isOwner() {
        require(msg.sender == contract_owner, "!Owner");
        _;
    }

    /*
    * @dev:
    *
    * Moves ownership of conract from `contract_owner` to `new_contract_owner`.
    * 
    *
    * @param:
    * 
    * address new_contract_owner.
    */
    function moveOwnership(address new_contract_owner) public isOwner {
        require(new_contract_owner != address(0), "0 Address");
        contract_owner = new_contract_owner;
        emit MoveOwnership(msg.sender, new_contract_owner);
    }
}
