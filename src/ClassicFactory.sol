// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Item.sol";

contract ClassicFactory {
    Item item;

    function create(uint256 _number) public {
        item = new Item(_number);
    }

    function getNumber() public view returns (uint256) {
        return item.number();
    }
}

contract ClassicFactoryWithConstructor {
    Item item;

    constructor(uint256 _number) {
        item = new Item(_number);
    }
}
