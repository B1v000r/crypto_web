// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
    IPUniqueness
    -------------
    This module tracks uniqueness of IP addresses using hashed values.
    Real IP addresses are never stored on-chain.
    The hash must be generated off-chain (backend/oracle).
*/

contract IPUniqueness {

    // Stores whether an IP hash was already used
    mapping(bytes32 => bool) private usedIPHashes;

    // Optional: bind IP to a wallet address
    mapping(address => bytes32) public addressToIP;

    event IPRegistered(address indexed user, bytes32 ipHash);

    /*
        Registers a hashed IP address.
        Reverts if the IP hash was already used.
    */
    function registerIP(bytes32 ipHash) external {
        require(ipHash != bytes32(0), "Invalid IP hash");
        require(!usedIPHashes[ipHash], "IP already used");

        // Mark IP as used
        usedIPHashes[ipHash] = true;

        // Optionally bind IP to wallet
        addressToIP[msg.sender] = ipHash;

        emit IPRegistered(msg.sender, ipHash);
    }

    /*
        Checks whether an IP hash is unique (not yet used).
    */
    function isIPUnique(bytes32 ipHash) external view returns (bool) {
        return !usedIPHashes[ipHash];
    }

    /*
        Checks whether a user already registered an IP.
    */
    function hasRegisteredIP(address user) external view returns (bool) {
        return addressToIP[user] != bytes32(0);
    }
}
