pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract YouTubeThumbnailToken is ERC721Token, Ownable {

 struct YouTubeThumbnail {
    string author;
    string dateCreated;
  }

  mapping(uint256 => YouTubeThumbnail) youTubeThumbnails;
  mapping(string => uint256) videoIdsCreated;

  constructor(string name, string symbol) ERC721Token(name, symbol) public {}

  function mintYTT(
    string _videoId,
    string _author,
    string _dateCreated,
    string _tokenURI
  )
    public
    payable
  {
    require(videoIdsCreated[_videoId] == 0);
    uint256 tokenId = totalSupply().add(1);
    youTubeThumbnails[tokenId] = YouTubeThumbnail(_author, _dateCreated);
    videoIdsCreated[_videoId] = tokenId;

    _mint(msg.sender, tokenId);
    _setTokenURI(tokenId, _tokenURI);

    owner.transfer(msg.value);
  }

  function getYTT(uint256 _tokenId) public view returns (string, string) {
    return (youTubeThumbnails[_tokenId].author, youTubeThumbnails[_tokenId].dateCreated);
  }

  function isTokenAlreadyCreated(string _videoId) public view returns (bool) {
    return videoIdsCreated[_videoId] != 0 ? true : false;
  }
}