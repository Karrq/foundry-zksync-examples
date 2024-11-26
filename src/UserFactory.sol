// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ClassicFactory.sol";

contract UserFactory {
    function create(address classicFactory, uint256 _number) public {
        ClassicFactory(classicFactory).create(_number);
    }

    function getNumber(address classicFactory) public view returns (uint256) {
        return ClassicFactory(classicFactory).getNumber();
    }
}
