// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./Owned.sol";


/*
* @title: Sellable smart contract, funded with tokens.
* @author: Anthony (fps) https://github.com/fps8k .
* @dev: 
* This smart contract involves an contract_owner depositing tokens into the smart contract, then he can list the smart contract for sale.
* The buyer then purchases the smart contract and can take the tokens in the smart contract.
*/

contract Sellable is Owned
{
    // isOwner from Owned.


    // Toggle for the sale and non-sale of the contract.

    bool private on_sale = false;


    // The highest bid, highest bidder

    uint256 private highest_bid;
    address private highest_bidder;

    uint256 private contract_price;
    uint256 private stored_contract_tokens;




    /*
    * @dev:
    *
    * Allows the `contract_owner` of the contract to deposit some of his tokens into the contract.
    * Only the `contract_owner` of the contract can deposit tokens.
    *
    * The `contract_owner` must have some allowance given to himself on the tokens he wants to deposit.
    * The contract must not be on sale for this function to be called.
    */

    function depositTokens(address _token, uint256 _amount) public isOwner
    {
        require(!on_sale, "Contract is on sale");
        require(_token != address(0), "Zero token address");

        IERC20 token = IERC20(_token);

        // Token holder will give contract some allowance after deployment.
        require(token.allowance(msg.sender, address(this)) >= _amount, "You don't have enough allowance tokens.");
        token.transferFrom(msg.sender, address(this), _amount);

        stored_contract_tokens += _amount;
    }




    /*
    * @dev:
    *
    * The contract must not be on sale for this function to be called.
    * This allows the contract_owner to place a price on his contract.
    * The maximum allowed for contract sale is 8 ether.
    * Turns on `on_sale` to true.
    *
    * The contract must have a minimum of tokens before it can be listed for sale, say 100.
    */

    function placeOnSaleInGwei(uint256 _amount) public isOwner
    {
        require(!on_sale, "Contract is for sale at the moment.");                           // Req on_sale == False;
        require(stored_contract_tokens >= 50, "There must be a minimum of 100 tokens to list contract on sale.");
        require(_amount <= 8 ether, "Amount must be <= 8 ether.");
        on_sale = !on_sale;
        contract_price = _amount;
    }



    /*
    * @dev:
    * 
    * Allows anyone to bid as long as their bid >= contract price and > highest bid standing set in the placeOnSaleInGwei.
    * The contract must be on sale.
    * Bidder cannnot be a 0 address.
    * Msg.value must be >= contract price and > highest_bid.
    *
    * This pays back the amount the old highest bidder had.
    * New highest bidder and new highest bid replaces the old spots.
    */

    function bidContract() public payable
    {
        require(on_sale, "Contract is not for sale at the moment.");                        // Req on_sale == True;
        require(msg.sender != address(0), "Txn from 0 address.");
        require(msg.sender != contract_owner, "You cannot bid your contract.");
        require(msg.value > 0, "Price <= 0");
        require(msg.value >= contract_price, "Bid < Contract price.");
        require(msg.value > highest_bid, "Yours isn't the highest, it is unaccepted.");


        if (highest_bid > 0 && highest_bidder != address(0))
            payable(highest_bidder).transfer(highest_bid);

            delete highest_bidder;
            delete highest_bid;


        highest_bid = msg.value;
        highest_bidder = msg.sender;
    }




    /*
    * @dev:
    *
    * Sells the contract to the highest bidder.
    * Makes the highest bidder the contract_owner.
    * Sets the on sale to false.
    */

    function sellContract() public isOwner
    {
        require(on_sale, "Not on sale");                                            // Req on_sale == True;
        require(highest_bid > 0, "No bids yet.");
        require(highest_bidder != address(0), "No bidder yet.");

        address old_contract_owner = contract_owner;

        payable(contract_owner).transfer(highest_bid);
        moveOwnership(highest_bidder);

        delete highest_bidder;
        delete highest_bid;
        
        on_sale = !on_sale;                                                         // on_sale == False;

        emit MoveOwnership(old_contract_owner, contract_owner);
    }




    /*
    * @dev:
    *
    * Cancels the sale and repays the current highest bidder.
    */

    function revokeSale() public isOwner
    {
        require(on_sale, "Contract not on sale.");
        on_sale = !on_sale;

        if (highest_bid > 0 && highest_bidder != address(0))
            payable(highest_bidder).transfer(highest_bid);

        delete highest_bidder;
        delete highest_bid;
    }
}