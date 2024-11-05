// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Maths} from "./Maths.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number = Maths.add(number, 1);
    }
}
