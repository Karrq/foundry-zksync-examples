// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ClassicFactory.sol";

contract NestedFactory {
    ClassicFactory nested;

    function create(uint256 _number) public {
        nested = new ClassicFactory();

        nested.create(_number);
    }

    function getNumber() public view returns (uint256) {
        return nested.getNumber();
    }
}
