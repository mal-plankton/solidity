/**
 * Call Honeypot
 * 
 * Original contract (2017): https://etherscan.io/address/0xd8993f49f372bb014fb088eabec95cfdc795cbf6#code
 *  Similar trap (2018): https://etherscan.io/address/0x13c547Ff0888A0A876E6F1304eaeFE9E6E06FC4B#code
 *
 * This contract pretends to be a gift left by one person to another with a weak vulnerability
 *
 *  Updated for Solidity 0.8.17
 *  Explanation in comments at the bottom
 */

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;

contract Scam_Honeypot_Gift {
    
    bool passHasBeenSet = false;
    bytes32 public hashPass;
    
    receive() external payable {}
    
    function GetHash(bytes calldata pass) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(pass));
    }
    
    function SetPass(bytes32 hash) public payable {
        if((!passHasBeenSet) && (msg.value >= 1 ether)) {
            hashPass = hash;
        }
    }
    
    function GetGift(bytes calldata pass) public payable {
        if(hashPass == keccak256(abi.encodePacked(pass))) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }
    
    function PassHasBeenSet(bytes32 hash) public {
        if(hash == hashPass) {
           passHasBeenSet = true;
        }
    }
}


///////////////////////////////////////
///////////////////////////////////////

/** 
 * This is a honeypot for devs with a bait vulnerability
 * 
 * The Bait Vulnerability: In the "SetPass()" function, they replaced <pass> with <hash> to try to make it look like they made an accidental typo.
 *   "SetPass(bytes32 hash)" is supposed to be "SetPass(bytes32 pass)"
 *   "hashPass = hash;" should be "hashPass = keccak256(abi.encodePacked(pass));"
 *   <pass> is actually a hash itself, so you need to know the original password to use "GetGift()"
 * 
 * The Trap: A dev might think that they could run "SetPass()" again with a new hash to reset the password. However, the value of <passHasBeenSet> is private and unknown.
 * Since internal transactions are hidden on blockchain explorers, the scammer was able to secretly call PassHasBeenSet() from another contract, like the "Secretly_Set_PassHasBeenSet" contract below.
 *   So <passHasBeenSet> was secretly already set to true by the scammer.
 *   If <passHasBeenSet> were public, it would've been easy to see the scam.
 * 
 * Best practices:
 *   1. Keep an eye out of strange functions that seem to have no purpose like PassHasBeenSet(). Normally, you wouldn't even create a separate function to set the <passHasBeenSet> boolean. If there is a weird function, it's a red flag that it could be called by another secret contract.
 *   2. The requirement that you need to send 1 ETH to change the password is a red flag. It serves no purpose except to extract value from the victim.
 */

 // Used to secretly call contract Scam_Honeypot_Gift to set <passHasBeenSet> to true
contract Secretly_Set_PassHasBeenSet {
    function update_PassHasBeenSet(address _honeypot_contract, bytes32 hash) public {
        (bool success, bytes memory data) = _honeypot_contract.call(abi.encodeWithSignature("PassHasBeenSet(bytes32)", hash));
    }
}