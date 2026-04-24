// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
    NFTGate
    --------
    Allows access only if user owns a specific NFT
*/

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256);
}

contract NFTGate {

    address public admin;

    // NFT contract address
    address public nftContract;

    event NFTContractUpdated(address nft);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor(address _nftContract) {
        admin = msg.sender;
        nftContract = _nftContract;
    }

    /*
        Check if user owns at least 1 NFT
    */
    function hasAccess(address user) public view returns (bool) {
        return IERC721(nftContract).balanceOf(user) > 0;
    }

    /*
        Update NFT collection
    */
    function setNFTContract(address _nft) external onlyAdmin {
        nftContract = _nft;
        emit NFTContractUpdated(_nft);
    }
}
