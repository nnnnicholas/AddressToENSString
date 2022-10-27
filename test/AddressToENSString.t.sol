// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AddressToENSString.sol";

contract AddressToENSStringTest is Test {
    AddressToENSString c;
    function setUp() public {
        c = new AddressToENSString();
    }

    function testGetName() public {
        assertEq(c.getName(0xAF28bcB48C40dBC86f52D459A6562F658fc94B1e), "dao.jbx.eth"); // known record
        // assertEq(c.getNameWithFallback(0xA2C122BE93b0074270ebeE7f6b7292C7deB45047), "0xa2c122be93b0074270ebee7f6b7292c7deb45047"); // No ENS name
    }
}
