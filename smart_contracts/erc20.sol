// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FungibleTokenContract is ERC20 {
    uint8 private _decimals;
    uint256 public _maxSupply;
    address public _contractOwner;
    string private _rate;
    string private _fiat;

    constructor(string memory name, string memory symbol, uint8 decimals_, uint256 maxSupply_, string memory rate_, string memory fiat_) ERC20(name, symbol) {
         _decimals = decimals_;
        _maxSupply = maxSupply_*(10**_decimals);
        _rate = rate_;
        _fiat = fiat_;
        _contractOwner = msg.sender;
    }

    function mint(address account, uint256 amount) public {
        require(totalSupply() + amount*(10**_decimals) <= _maxSupply, "Max supply exceeded");
        require(msg.sender == contractOwner(), "ERC20: only the contract owner can issue tokens");
        _mint(account, amount*(10**_decimals));
    }

     function contractOwner() public view returns(address) {
        return _contractOwner;
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

    function burn(address account,  uint256 amount) public{
        require(amount > 0, "Amount must be greater than 0");
        _burn(account, amount);
    }

}
