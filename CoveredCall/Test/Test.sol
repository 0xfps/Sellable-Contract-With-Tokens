// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import "../Covered.sol";
import "../USDT.sol";

contract Test is Sellable, USDT
{
    address private usdt_address;

    USDT usdt = USDT(usdt_address);
    Sellable sellable = new Sellable();


    function setUSDTAddress(address _usdt_address) public
    {
        require(_usdt_address != address(0), "This is a zero address");
        usdt_address = _usdt_address;
    }
}