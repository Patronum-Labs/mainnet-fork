// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IERC1820Registry
 * @dev Interface for the ERC1820 registry contract as per the ERC1820 standard.
 */
interface IERC1820Registry {
    /**
     * @notice Set the implementer of a specific interface for a given address.
     * @dev Registers a contract as the implementer of a given interface for a specific address.
     * @param _addr The address for which the interface implementer is being set.
     * @param _interfaceHash The keccak256 hash of the name of the interface.
     * @param _implementer The address of the implementer contract.
     */
    function setInterfaceImplementer(
        address _addr,
        bytes32 _interfaceHash,
        address _implementer
    ) external;
}
