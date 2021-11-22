//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// importing some opnZepplin contracts
import "@openZeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openZeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// we have to inherit the imported contracts methods into our contract
contract MyEpicNFT is ERC721URIStorage {
    // given to us by xeppelin to help us keep track of tokenIds
    using Counters for Counters.Counter;   
    Counters.Counter private _tokenIds;

    //we need to pass thee name of the nft token and symbol
    constructor () ERC721 ("SquareNFT", "SQUARE") {
        console.log("This time were making nfts");
    }

    // this is the function that will be called by the user to get their nft
    function makeAnEpicNFT() public {
        // we need to get the current tokenId. it starts at 0
        uint256 newItemId = _tokenIds.current();

        // mint the nft to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        // set the NFTs data
        _setTokenURI(newItemId, "heyyyo");

        //incrememnt the counter for when the next nft is minted
        _tokenIds.increment();
    } 
}