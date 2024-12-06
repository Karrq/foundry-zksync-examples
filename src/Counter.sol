// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Maths} from "./Maths.sol";

contract Counter {
    uint256 public number;

    constructor() {
        number = 0;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number = Maths.add(number, 1);
    }
}
