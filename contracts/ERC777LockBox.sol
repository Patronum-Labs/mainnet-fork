// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC1820Registry} from "./interfaces/IERC1820Registry.sol";

/**
 * @title ERC777LockBox
 * @dev A contract that implements the ERC777 tokensReceived hook to register received tokens and maintain a blacklist.
 * This is a mock contract and not intended to be used for production.
 */
contract ERC777LockBox is Ownable {
    // The address of the LYXe token contract.
    address public constant LYX_TOKEN_CONTRACT_ADDRESS =
        0xA8b919680258d369114910511cc87595aec0be6D;

    // The address of the registry contract (ERC1820 Registry)
    address public constant ERC1820_REGISTRY_ADDRESS =
        0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24;

    // ERC1820 Interface hash for the ERC777 tokens recipient
    bytes32 private constant _TOKENS_RECIPIENT_INTERFACE_HASH =
        keccak256("ERC777TokensRecipient");

    // Mapping to track registered addresses
    mapping(address => bool) private _registered;

    // Mapping to track blacklisted addresses
    mapping(address => bool) private _blacklist;

    /**
     * @dev Constructor that registers the contract as an ERC777 tokens recipient.
     */
    constructor(address owner_) Ownable(owner_) {
        // Set this contract as the implementer of the tokens recipient interface in the registry contract
        IERC1820Registry(ERC1820_REGISTRY_ADDRESS).setInterfaceImplementer(
            address(this),
            _TOKENS_RECIPIENT_INTERFACE_HASH,
            address(this)
        );
    }

    /**
     * @notice Handle the receipt of ERC777 tokens.
     * @dev This function is called by an ERC777 token contract when tokens are sent.
     * @param from The address from which the tokens are sent.
     * @dev operator The address performing the send operation.
     * @dev to The address to which the tokens are sent.
     * @dev amount The amount of tokens sent.
     * @dev userData Additional data with no specified format.
     * @dev operatorData Additional data with no specified format from the operator.
     */
    function tokensReceived(
        address /* operator */,
        address from,
        address /* to */,
        uint256 /*amount*/,
        bytes calldata /*userData*/,
        bytes calldata /* operatorData */
    ) external {
        // solhint-disable-next-line reason-string
        require(!_blacklist[from], "ERC777LockBox: sender is blacklisted");

        if (!_registered[from]) {
            _registered[from] = true;
        }
    }

    /**
     * @notice Blacklist an address.
     * @dev Adds the specified address to the blacklist. Can only be called by the contract owner.
     * @param account The address to blacklist.
     */
    function blacklistAddress(address account) external onlyOwner {
        _blacklist[account] = true;
    }

    /**
     * @notice Remove an address from the blacklist.
     * @dev Removes the specified address from the blacklist. Can only be called by the contract owner.
     * @param account The address to remove from the blacklist.
     */
    function unblacklistAddress(address account) external onlyOwner {
        _blacklist[account] = false;
    }

    /**
     * @notice Check if an address is blacklisted.
     * @param account The address to query.
     * @return True if the address is blacklisted, false otherwise.
     */
    function isBlacklisted(address account) external view returns (bool) {
        return _blacklist[account];
    }

    /**
     * @notice Check if an address is registered.
     * @param account The address to query.
     * @return True if the address is registered, false otherwise.
     */
    function isRegistered(address account) external view returns (bool) {
        return _registered[account];
    }
}
