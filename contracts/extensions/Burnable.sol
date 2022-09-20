// SPDX-License-Identifier: MIT
// BaoKuNFT Contracts  (./extensions/Burnable.sol)

pragma solidity ^0.8.0;

import "../utils/Context.sol";


/**
 * @dev Extension of {ERC1155} that allows token holders to destroy both their
 * own tokens and those that they have been approved to use.
 *
 * _Available since v3.1._
 */
abstract contract Burnable is Context {

    /**
     * @dev Emitted when the burn is triggered by `account`.
     */
    event BurnEnabled(address account);

    /**
     * @dev Emitted when the burn is lifted by `account`.
     */
    event BurnDisabled(address account);

    bool private _burnEnabled;

    /**
     * @dev Initializes the contract in disable burn state.
     */
    constructor() {
        _burnEnabled = false;
    }

    /**
     * @dev Modifier to make a function callable only when the token is not enabled burn.
     *
     * Requirements:
     *
     * - The token is disabled burn.
     */
    modifier whenBurnDisabled() {
        _requireBurnDisabled();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the token is enabled burn.
     *
     * Requirements:
     *
     * - The token is enabled burn.
     */
    modifier whenBurnEnabled() {
        _requireBurnEnabled();
        _;
    }

    /**
     * @dev Returns true if the token is burnable, and false otherwise.
     */
    function burnEnabled() public view virtual returns (bool) {
        return _burnEnabled;
    }

    /**
     * @dev Throws if the token is enabled burn.
     */
    function _requireBurnDisabled() internal view virtual {
        require(!burnEnabled(), "Burnable: token enabled burn");
    }

    /**
     * @dev Throws if the token is disabled burn.
     */
    function _requireBurnEnabled() internal view virtual {
        require(burnEnabled(), "Burnable: not able to burn token");
    }

    /**
     * @dev Triggers burnable state.
     *
     * Requirements:
     *
     * - The token must be able to burn.
     */
    function _enableBurn() internal virtual whenBurnDisabled {
        _burnEnabled = true;
        emit BurnEnabled(_msgSender());
    }

    /**
     * @dev Returns to burn disable state.
     *
     * Requirements:
     *
     * - The token must be burnable state.
     */
    function _disableBurn() internal virtual whenBurnEnabled {
        _burnEnabled = false;
        emit BurnDisabled(_msgSender());
    }
}