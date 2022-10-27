//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title AddressToENSString
/// @author nnnnicholas
/// @notice Given an address, return the ENS name associated with it, or fallback to a stringified version of the address if no ENS name is found.

// Reverse Resolution Interfaces
interface IReverseRegistrar {
    function node(address) external view returns (bytes32);
}

interface IReverseResolver {
    function name(bytes32) external view returns (string memory); // reverse
}

interface IForwardResolver {
    function addr(bytes32 node) external view returns (address); // forward
}

// Forward Resolution Interfaces
interface IENS {
    function resolver(bytes32 node) external view returns (IForwardResolver);
}

contract AddressToENSString {
    IReverseRegistrar reverseRegistrar =
        IReverseRegistrar(0x084b1c3C81545d370f3634392De611CaaBFf8148);
    IReverseResolver reverseResolver =
        IReverseResolver(0xA2C122BE93b0074270ebeE7f6b7292C7deB45047);
    IENS ens = IENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);

    function getName(address _addr) public view returns (string memory) {
        // Reverse
        bytes32 reportedNode = reverseRegistrar.node(_addr);
        string memory name = reverseResolver.name(reportedNode);

        // Forward
        IForwardResolver forwardResolver = IForwardResolver(
            ens.resolver(reportedNode) // TODO BROKEN
        );
        address resolvedAddress = forwardResolver.addr(reportedNode);

        // Comparison
        if (resolvedAddress == _addr) {
            return name;
        } else {
            return "";
        }
    }

    function getNameWithFallback(address _addr)
        public
        view
        returns (string memory)
    {
        // string memory name = resolver.name(reverseRegistrar.node(_addr));
        // //TODO Forward resolution
        // if (bytes(name).length > 0) {
        //     return name;
        // } else {
        //     return string(abi.encodePacked("0x", toAsciiString(_addr)));
        // }
    }

    // borrowed from https://ethereum.stackexchange.com/questions/8346/convert-address-to-string
    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
