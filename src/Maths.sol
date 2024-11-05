// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.7 <0.9.0;

library Maths {
    function add(uint a, uint b) public returns (uint c) {
        c = a + b;
    }

    function mul(uint a, uint b) public returns (uint c) {
        c = a * b;
    }

    function square(uint a) public returns (uint c) {
        c = mul(a, a);
    }
}
