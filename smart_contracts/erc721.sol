// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => string) private _tokenURIs;
    string private _contractDescription;
    address public _contractOwner;
    event TokenMinted(address indexed owner, uint256 indexed tokenId);

    constructor(string memory _name, string memory _symbol, string memory description) ERC721(_name, _symbol) {
        _contractOwner = msg.sender;
        _contractDescription = description;
    }

    function safeMint(address to, string memory metadataURI) public onlyOwner {
        require(msg.sender == contractOwner(), "ERC721: only the contract owner can mint tokens");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, metadataURI);
        emit TokenMinted(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenURIs[tokenId];
    }

    function _setTokenURI(uint256 tokenId, string memory metadataURI) internal virtual {
        require(_exists(tokenId), "Token does not exist");
        _tokenURIs[tokenId] = metadataURI;
    }

    function totalSupply() public view returns(uint256){
        return _tokenIdCounter.current();
    }

    function contractDescription() public view returns(string memory){
        return _contractDescription;
    }

    function contractOwner() public view returns(address) {
        return _contractOwner;
    }


}