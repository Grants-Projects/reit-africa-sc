// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract PropertyOwnershipNFT is ERC721, Ownable {

 constructor() ERC721("PropertyOwnership", "REIT") {}

}