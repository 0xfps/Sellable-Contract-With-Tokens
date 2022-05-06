// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

/*
* @title: 
* @author: Anthony (fps) https://github.com/fps8k .
* @dev: 
*/

contract Owned
{
    address private owner;

    event TransferOwnership(address, address);

    constructor()
    {
        owner = msg.sender;  
        emit TransferOwnership(address(0), msg.sender);
    }

    modifier isOwner()
    {
        require(msg.sender == owner, "!Owner");
        _;
    }

    function transferOwnership(address new_owner) public isOwner
    {
        require(new_owner != address(0), "0 Address");
        owner = new_owner;
        emit TransferOwnership(msg.sender, new_owner);
    }
}