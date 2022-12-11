/**
 * State variable shadowing Honeypot
 * 
 * Original contract (2017): https://etherscan.io/address/0x4dc76cfc65b14b3fd83c8bc8b895482f3cbc150a#code
 *   Similar trap (2018): https://etherscan.io/address/0xe65c53087e1a40b7c53b9a0ea3c2562ae2dfeb24#code
 *
 *  Updated for Solidity 0.5.17. Doesn't work past 0.5.x.
 *  Explanation in comments at the bottom
 */
 
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.10;

// Simple Game. Each time you send more than the current jackpot, you become
// owner of the contract. As an owner, you can take the jackpot after a delay
// of 5 days after the last payment.

contract Owned {
    address owner = msg.sender;
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
}

contract KingOfTheHill is Owned {
    address public owner;
    uint public jackpot;
    uint public withdrawDelay;

    function() external payable {
        // transfer contract ownership if player pay more than current jackpot
        if (msg.value > jackpot) {
            owner = msg.sender;
            withdrawDelay = block.timestamp + 5 days;
        }
        jackpot+=msg.value;
    }

    function takeAll() public onlyOwner {
        require(block.timestamp >= withdrawDelay);
        msg.sender.transfer(address(this).balance);
        jackpot=0;
    }
}



///////////////////////////////////////
///////////////////////////////////////

/** 
 * This is a honeypot and scam
 * 
 * The Bait Vulnerability: None
 * 
 * The Trap: This requires you to know about State Variable Shadowing, which was disallowed after Solidity 0.6.0.
 *   Prior to 0.6.0, you could declare a variable of the same name in both the base contract (Owned) and the derived contract (KingOfTheHill).
 *   The <owner> variable used in the <onlyOwner> modifier of the Owned contract is NOT the same as the public <owner> in the KingOfTheHill contract.
 *   Those interacting with the contract think the public <owner> is being changed when the true private <owner> used by the onlyOwner modifier for the takeAll() function is the original deployer of the contract.
 * 
 * Best practices:
 *   1. Be careful playing with contracts using old Solidity versions
 *   1. Always do testing with the same Solidity version of the contract
 */