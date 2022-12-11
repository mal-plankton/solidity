/**
 * Balance Honeypot
 * 
 * Original contract (2017): https://etherscan.io/address/0x5aa88d2901c68fda244f1d0584400368d2c8e739#code
 *   Similar trap (2018): https://etherscan.io/address/0x35c3034556b81132e682db2f879e6f30721b847c
 *
 *  Updated for Solidity 0.8.17
 *  Explanation in comments at the bottom
 */

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;

contract Scam_Honeypot_Balance {
    address public Owner = msg.sender;
   
    receive() external payable {}
   
    function Withdraw() payable public {
        require(msg.sender == Owner);
        payable(Owner).transfer(address(this).balance);
    }
    
    function Take_balance(address adr) public payable {
        if(msg.value >= address(this).balance) {
            payable(adr).transfer(address(this).balance + msg.value);
        }
    }
}

///////////////////////////////////////
///////////////////////////////////////

/** 
 * This is a very simple honeypot for devs with a bait vulnerability.
 *
 * The Bait Vulnerability: Anyone can call the Take_balance() function, and there are no restrictions in it except that the value sent has to be greater than its current balance.
 * 
 * The Trap: "address(this).balance" always includes any msg.value that's currently being sent to it
 *   So address(this).balance is always >= msg.value and that if() statement will never be true unless the balance were 0.
 * 
 * Best practices:
 *   1. Test contracts in a dev environment before interacting with them
 *   2. The requirement that the msg.value sent needs to be greater than the current balance is a giant red flag. It serves no purpose other than to make the sender deposit more ETH to the contract.
 */