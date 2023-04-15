// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ReitAfrica is Ownable {

    struct Property {
        uint256 id;
        string name;
        string metadataUrl;
        string propertyIdentifier;
        uint256 valuation;
        uint256[] splitIds;
    }

    struct PropertySplit {
        uint256 id;
        uint256 propertyId;
        address owner;
        string metadataUrl;
        string splitIdentifier;
        uint64 lastSaleTimestamp;
        bool onSale;
    }

    struct PurchaseOffer {
        uint256 id;
        uint256 offeredValue;
        address buyer;
        uint256 splitId;

    }

    uint256 public minimumPropertyValue;

    PurchaseOffer[] public purchaseoffers;
    Property[] public properties;
    PropertySplit[] public propertySplits;
    
    function _createProperty(
        string memory name
        , string memory metadataUrl
        , uint256 propertyValuation
        , string[] memory splitMetadataUrls
        , string memory propertyIdentifier
        , address owner
    ) private {
        require(propertyValuation >= minimumPropertyValue, "Value of property must be greater than minimum");

        uint256 propertyId = properties.length + 1;
        uint256 numberOfSplits = splitMetadataUrls.length;
        uint256[] memory splitIds = new uint256[](numberOfSplits);

        for (uint256 i = 0; i < numberOfSplits; i++) {
            PropertySplit memory split = PropertySplit (
                propertySplits.length + 1,
                propertyId,
                owner,
                splitMetadataUrls[i],
                _createSplitId(propertyIdentifier, i + 1),
                0,
                false
            );

            splitIds[i] = split.id;
            propertySplits.push(split);
        }

        properties.push(Property (
            propertyId,
            name,
            metadataUrl,
            propertyIdentifier,
            propertyValuation,
            splitIds
        ));
    }

    

    function setPropertyValuation(uint256 propertyId, uint256 newValue) public onlyOwner {
        _setPropertyValuation(propertyId, newValue);
    }

    function _setPropertyValuation(uint256 propertyId, uint256 newValue) private {

        require(newValue >= minimumPropertyValue, "Value of property must be greater than minimum");

        properties[propertyId - 1].valuation = newValue;

    }

    function _createSplitId(string memory propertyIdentifier, uint256 splitIndex) private pure returns (string memory splitIdentifier) {
        string memory idAsString = Strings.toString(splitIndex);
        uint256 idLength = bytes(idAsString).length;

        string memory zeroSpacing = "";
        while (idLength < 4) {
            zeroSpacing = string.concat(zeroSpacing, "0");
            idLength++;
        }
        splitIdentifier = string.concat(propertyIdentifier, zeroSpacing, idAsString);
    }





}