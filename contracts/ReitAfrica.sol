// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ReitAfrica is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _propertyCount;
    Counters.Counter private _purchaseHistoryCount;

    struct Property {
        uint256 propertyId;
        string name;
        string metadataUrl;
        string latitude;
        string longitude;
        uint256 totalShares;
        uint256 availableShares;
        uint256 price;
        bool isApproved;
        uint256 dateCreated;
    }

    struct PropertyShareOwned {
        uint256 propertyId;
        uint256 sharesOwned;
    }

    struct PurchaseHistory {
        address owner;
        uint256 propertyId;
        uint256 sharesBought;
        uint256 DateBought;
        uint256 price; 
    }

    mapping(uint256 => Property) public properties;

    mapping(uint256 => mapping(address => uint256)) sharesOwned;

    mapping(uint256 => PurchaseHistory) purchaseHistory;


    event PropertyAdded(
        uint256 id,
        string name,
        string latitude,
        string longitude,
        uint256 price,
        uint256 createdDate
    );

    event BuyShare(uint256 propertyId, address buyer, uint256 price, uint256 dateBought, uint256 sharesBought);

    //Only owner can add property this is to prevent anyone to add unverified properties
    //Owner can specify the total share that will be available because if owner keeps spliting the property to make money
    //they could potentially dilute ownership of the property and affects other investors
    function addProperty(
        string memory _name,
        string memory _latitude,
        string memory _longitude,
        uint256 _price,
        string memory _metadataUrl,
        uint256 _totalShares
    ) public onlyOwner {
        _propertyCount.increment();
        uint256 propertyCount = _propertyCount.current();
        uint256 createdDate = block.timestamp;
        properties[propertyCount] = Property(
            propertyCount,
            _name,
            _metadataUrl,
            _latitude,
            _longitude,
            _totalShares,
            _totalShares,
            _price,
            false,
            createdDate
        );
        emit PropertyAdded(
            propertyCount,
            _name,
            _latitude,
            _longitude,
            _price,
            createdDate
        );
    }


    function approveProperty(uint256 _propertyId) public onlyOwner {
        Property storage property = properties[_propertyId];
        require(!property.isApproved, "Property has already been approved");
        property.isApproved = true;
    }


    function getPropertySharesCount(uint256 _propertyId) public view returns (uint256) {
        Property memory property = properties[_propertyId];
        return property.availableShares;
    }

    function buyShares(uint256 _propertyId, uint256 _sharesToBuy) public payable {
      Property storage property = properties[_propertyId];
      require(property.isApproved == true, "Property has not been approved");
      require(property.availableShares >= _sharesToBuy, "Not enough shares available");
      require(_sharesToBuy * property.price == msg.value, "Amount is incorrect");
      _purchaseHistoryCount.increment();
      uint256 purchaseHistoryCount = _purchaseHistoryCount.current();
      property.availableShares -= _sharesToBuy;
      sharesOwned[_propertyId][msg.sender]++;
      uint256 currentDate = block.timestamp;
      purchaseHistory[purchaseHistoryCount] = PurchaseHistory(msg.sender, _propertyId, _sharesToBuy, currentDate, property.price);
      emit BuyShare(_propertyId, msg.sender, property.price, currentDate, _sharesToBuy);
    }

    function setSharePrice(
        uint256 propertyId,
        uint256 newValue
    ) public onlyOwner {
        _setSharePrice(propertyId, newValue);
    }

    function _setSharePrice(
        uint256 propertyId,
        uint256 newValue
    ) private {
      properties[propertyId].price = newValue;
    }


}
