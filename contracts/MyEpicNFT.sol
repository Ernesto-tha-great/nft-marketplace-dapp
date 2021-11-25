//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// importing some opnZepplin contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import 'base64-sol/base64.sol';


// we have to inherit the imported contracts methods into our contract
contract MyEpicNFT is ERC721URIStorage {
    // given to us by xeppelin to help us keep track of tokenIds
    using Counters for Counters.Counter;   
    Counters.Counter private _tokenIds;

    //  svg code for the token
    // We split the SVG at the part where it asks for the background color.
  string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // arrays,each with their own theme of random words
    string[]  firstWords = ["itachi", "disco", "degenerate", "superstar", "vunderkind", "snape"];
    string[]  secondWords = ["relegate", "manchester", "united", "championship", "lord", "pain"];
    string[]  thirdWords = ["serenade", "harry", "yuno", "better", "than", "julius"];

 // Declaring a bunch of colors.
  string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    //we need to pass thee name of the nft token and symbol
    constructor () ERC721 ("SquareNFT", "SQUARE") {
        console.log("This time were making nfts");
    }

      // I create a function to randomly pick a word from each array.
        function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
            //I seed the random generator. More on this in the lesson.
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
            // Squash the # between 0 and the length of the array to avoid going out of bounds.
            rand = rand % firstWords.length;
            return firstWords[rand];
    }

        function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
            uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
            rand = rand % secondWords.length;
            return secondWords[rand];
        }

        function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
            uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
            rand = rand % thirdWords.length;
            return thirdWords[rand];
        }

          function pickRandomColor(uint256 tokenId) public view returns (string memory) {
            uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
            rand = rand % colors.length;
            return colors[rand];
            }

        function random(string memory input) internal pure returns (uint256) {
            return uint256(keccak256(abi.encodePacked(input)));
        }

    // this is the function that will be called by the user to get their nft
    function makeAnEpicNFT() public {
        // we need to get the current tokenId. it starts at 0
        uint256 newItemId = _tokenIds.current();

         // We go and randomly grab one word from each of the three arrays.
            string memory first = pickRandomFirstWord(newItemId);
            string memory second = pickRandomSecondWord(newItemId);
            string memory third = pickRandomThirdWord(newItemId);
            string memory combinedWord = string(abi.encodePacked(first, second, third));
              // Add the random color in.
    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);

     //incrememnt the counter for when the next nft is minted
    _tokenIds.increment();
     console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
     emit NewEpicNFTMinted(msg.sender, newItemId);
     
    }

 
}