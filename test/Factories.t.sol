// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

import "../src/Factory.sol";
import "../src/ClassicFactory.sol";
import "../src/UserFactory.sol";
import "../src/NestedFactory.sol";
import "../src/SuperNestedFactory.sol";

contract ZkFactoryTest is Test {
    function testClassicFactory() public {
        ClassicFactory factory = new ClassicFactory();
        factory.create(42);

        assert(factory.getNumber() == 42);
    }

    function testNestedFactory() public {
        NestedFactory factory = new NestedFactory();
        factory.create(42);

        assert(factory.getNumber() == 42);
    }

    function testSuperNestedFactory() public {
        SuperNestedFactory factory = new SuperNestedFactory();
        factory.create(42);

        assert(factory.getNumber() == 42);
    }

    function testUserFactory() public {
        ClassicFactory factory = new ClassicFactory();
        UserFactory user = new UserFactory();
        user.create(address(factory), 42);

        assert(user.getNumber(address(factory)) == 42);
    }
}
