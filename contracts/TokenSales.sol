pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TokenSales {

  ERC721Token public nftAddress;

  mapping(uint256 => uint256) public tokenPrice;

  constructor(address _tokenAddress) public {
    nftAddress = ERC721Token(_tokenAddress);
  }

  function setForSale(uint256 _tokenId, uint256 _price) public {
    address tokenOwner = nftAddress.ownerOf(_tokenId);
    require(_price > 0);
    require(tokenOwner == msg.sender);
    require(nftAddress.isApprovedForAll(tokenOwner, address(this)));
    tokenPrice[_tokenId] = _price;
  }

  function purchaseToken(uint256 _tokenId) public payable {
    uint256 price = tokenPrice[_tokenId];
    address tokenSeller = nftAddress.ownerOf(_tokenId);
    require(msg.value >= price);
    require(msg.sender != tokenSeller);
    tokenSeller.transfer(msg.value);
    nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
    tokenPrice[_tokenId] = 0;
  }

  function removeTokenOnSale(uint256[] tokenIds) public {
    require(tokenIds.length > 0);

    for (uint i = 0; i < tokenIds.length; i++) {
      uint256 tokenId = tokenIds[i];
      address tokenSeller = nftAddress.ownerOf(tokenId);
      require(msg.sender == tokenSeller);
      tokenPrice[tokenId] = 0;
    }
  }
}