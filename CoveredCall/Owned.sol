// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/*
* @title: 
* @author: Anthony (fps) https://github.com/fps8k .
* @dev: 
*/

contract Owned
{
    address internal contract_owner;

    event MoveOwnership(address, address);

    constructor()
    {
        contract_owner = msg.sender;  
        emit MoveOwnership(address(0), msg.sender);
    }

    modifier isOwner()
    {
        require(msg.sender == contract_owner, "!Owner");
        _;
    }

    function moveOwnership(address new_contract_owner) public isOwner
    {
        require(new_contract_owner != address(0), "0 Address");
        contract_owner = new_contract_owner;
        emit MoveOwnership(msg.sender, new_contract_owner);
    }
}