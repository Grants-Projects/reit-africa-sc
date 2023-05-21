// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.12;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


// contract PropertyOwnershipNFT is ERC721, Ownable {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;

//     uint256 propoertyCount;

// struct Property {
//     string name;
//     string propertyType;
//     int latitude;
//     int longitude;
//     uint256 sharePrice;
//     uint256 tokenId;
//     uint256 remainingShare;
//     bool forSale;
    
// }

// struct ShareHolders {
//     address holders;
//     uint256 tokenId;
//     uint256 share;
// }
 

// mapping(uint256 => Property) public ownerToProperty;
// //mapping(address => mapping(uint256 => Property[])) public ownerToTokenIdToProperty;
// mapping(uint256 => ShareHolders[]) public shareHolders;

//  constructor() ERC721("PropertyOwnership", "REIT") {}

// //The owner can decide to mint more share //this assumes that the owner mints initial shares at the beginning
//  function mintProperty(string memory tokenURI, uint256 sharePrice, string memory name, string memory propertyType, int latitude, int longitude ) public onlyOwner returns (uint256){
//    require(msg.sender != address(0));
//    require(sharePrice > 0, "sharePrice must be more than 0");
//    _tokenIds.increment();
//    uint256 newTokenId = _tokenIds.current();
//    _safeMint(msg.sender, newTokenId);
//    _setTokenURI(newTokenId, tokenURI);

//    ownerToProperty[newTokenId] = Property(name, propertyType, latitude, longitude, sharePrice, newTokenId, 100, true);
//    //ownerToTokenIdToProperty[msg.sender][newTokenId].push(Property(name, propertyType, latitude, longitude, sharePrice, newTokenId, true));

//    return newTokenId;

//  }

//  function buyShare(uint256 tokenId, address memory stakeHolder, uint256 numberOfShare) public payable {
//     address owner = ownerOf(tokenId);
//     Property memory property = Property[tokenId];
//       require(msg.value == property.sharePrice * numberOfShare, "Insufficient fund");
//     require(property.forSale, "This property is not for sale");
//     require(property.remainingShare > 0, "No available share for this property");
//     require(property.remainingShare >= numberOfShare, "The available share is less that the share you wnat to purchase");


//     //Transfer NFT ownership to contract
//     safeTransferFrom(owner, address(this), tokenId);

//     //split NFT to this stake holder

//     for(uint256 i = 0; i < numberOfShare; i++){
//         _safeMint(msg.sender, tokenId);
//     }
//     property[tokenId].remainingShare -= numberOfShare;

//     shareHolders[tokenId].push(ShareHolders(msg.sender, tokenId, numberOfShare));

//  }



// }