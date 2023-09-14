// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract ERC20Whitelist is ERC20Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    mapping(address => bool) public transferWhitelist;
    uint8 private _decimals;
    uint256 public _maxSupply;
    string private _rate;
    string private _fiat;
    address public _contractOwner;

    constructor(
        string memory _name, string memory _symbol, uint8 decimals_, uint256 maxSupply_, string memory rate_, string memory fiat_) {
            __Ownable_init();
            __ReentrancyGuard_init();
            __ERC20_init(_name, _symbol);
            _decimals = decimals_;
            _maxSupply = maxSupply_ * (10**uint256(decimals_));
            _rate = rate_;
            _fiat = fiat_;
            _contractOwner = msg.sender;
    }

    function manageTransferWhiltelist(address[] memory _addressList, bool _isWhitelisted)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < _addressList.length; i++) {
            require(_addressList[i] != address(0), "ABTTestToken1: address is zero");
            transferWhitelist[_addressList[i]] = _isWhitelisted;
        }
    }

    function recall(
        address _from,
        address _to,
        uint256 _amount
    ) external onlyOwner {
        require(transferWhitelist[_to], "ABTTestToken1: address is not whitelisted");
        _transfer(_from, _to, _amount);
    }

    function bulkRecall(
        address[] memory _fromList,
        address _to,
        uint256 _amount
    ) external onlyOwner {
        require(transferWhitelist[_to], "ABTTestToken1: address is not whitelisted");
        for (uint256 i = 0; i < _fromList.length; i++) {
            _transfer(_fromList[i], _to, _amount);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(
            transferWhitelist[from] || from == address(0),
            "ABTTestToken1: address is not whitelisted"
        );
        require(
            transferWhitelist[to] || from == address(0),
            "ABTTestToken1: address is not whitelisted"
        );
        super._beforeTokenTransfer(from, to, amount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(transferWhitelist[to], "ABTTestToken1: address is not whitelisted");
        require(totalSupply() + amount*(10**_decimals) <= _maxSupply, "Max supply exceeded");
        _mint(to, amount);
    }

    function maxSupply() public view returns(uint256) {
        return _maxSupply;
    }
    
    function decimals() public override view returns (uint8) {
        return _decimals;
    }

    function rate() public view returns(string memory){
        return _rate;
    }

    function fiat() public view returns(string memory){
        return _fiat;
    }

    function contractOwner() public view returns(address) {
        return _contractOwner;
    }
}
