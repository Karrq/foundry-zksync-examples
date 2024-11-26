// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./NestedFactory.sol";

contract SuperNestedFactory {
    NestedFactory nestedFactory;

    function create(uint256 _number) public {
        nestedFactory = new NestedFactory();
        nestedFactory.create(_number);
    }

    function getNumber() public view returns (uint256) {
        return nestedFactory.getNumber();
    }
}
