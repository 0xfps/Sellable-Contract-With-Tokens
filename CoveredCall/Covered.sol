// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./Owned.sol";


/*
* @title: Sellable smart contract.
* @author: Anthony (fps) https://github.com/fps8k .
* @dev: 
* This smart contract involves an owner depositing tokens into the smart contract, then he can list the smart contract for sale.
* The buyer then purchases the smart contract and can take the tokens in the smart contract.
*/

contract Sellable is Owned
{
    // isOwner from Owned.
    bool private on_sale = false;

    function depositTokens(address _token, uint256 _amount) public isOwner
    {
        require(!on_sale, "Contract is on sale");
        require(_token != address(0), "Zero token address");

        IERC20 token = IERC20(_token);

        // Token holder will give contract some allowance after deployment.
        require(token.allowance(msg.sender, address(this)) >= _amount, "You don't have enough allowance tokens.");
        token.transferFrom(msg.sender, address(this), _amount);
    }




    function placeOnSale() public isOwner
    {
        on_sale = !on_sale;
    }

    function bidContract() public payable{}
    function sellContract() public isOwner{}
}