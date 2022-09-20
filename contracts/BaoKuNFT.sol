// SPDX-License-Identifier: MIT
// BaoKu Contracts (BaoKuNFT)

pragma solidity ^0.8.0;

import "./ERC1155.sol";
import "./security/AccessControlEnumerable.sol";
import "./security/pausable.sol";
import "./utils/Strings.sol";
import "./extensions/Burnable.sol";

// BaoKuNFT is mintable, pausable, burnable using metaUri
contract BaoKuNFT is ERC1155, AccessControlEnumerable, Pausable, Burnable {
    using Strings for uint256;

    // Optional base URI
    string private _baseURI = "";

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // preset roles for access
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor(string memory _uri) ERC1155(_uri){
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    /**
     * @dev Creates `amount` new tokens for `to`, of token type `id`.
     *
     * See {ERC1155-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual whenNotPaused {
        require(hasRole(MINTER_ROLE, _msgSender()), "BaokuNFT: must have minter role to mint");
        _mint(to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] variant of {mint}.
     */
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "BaokuNFT: must have minter role to mint");

        _mintBatch(to, ids, amounts, data);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC1155Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "BaokuNFT: must have pauser role to pause");
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC1155Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "BaokuNFT: must have pauser role to unpause");
        _unpause();
    }


    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the concatenation of the `_baseURI`
     * and the token-specific uri if the latter is set
     *
     * This enables the following behaviors:
     *
     * - if `_tokenURIs[tokenId]` is set, then the result is the concatenation
     *   of `_baseURI` and `_tokenURIs[tokenId]` (keep in mind that `_baseURI`
     *   is empty per default);
     *
     * - if `_tokenURIs[tokenId]` is NOT set then we fallback to `super.uri()`
     *   which in most cases will contain `ERC1155._uri`;
     *
     * - if `_tokenURIs[tokenId]` is NOT set, and if the parents do not have a
     *   uri value set, then the result is empty.
     */
    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        string memory tokenURI = _tokenURIs[tokenId];

        // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
        return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
    }

    function setURI(uint256 tokenId, string memory tokenURI) public virtual onlyRole(MINTER_ROLE){
        _setURI(tokenId, tokenURI);
    }

    function setBaseURI(string memory baseURI) public virtual onlyRole(MINTER_ROLE){
        _setBaseURI(baseURI);
    }

    /**
     * @dev Sets `tokenURI` as the tokenURI of `tokenId`.
     */
    function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
        _tokenURIs[tokenId] = tokenURI;
        emit URI(uri(tokenId), tokenId);
    }

    /**
     * @dev Sets `baseURI` as the `_baseURI` for all tokens
     */
    function _setBaseURI(string memory baseURI) internal virtual {
        _baseURI = baseURI;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(AccessControlEnumerable, ERC1155)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
 * @dev Extension of {ERC1155} that allows token holders to destroy both their
 * own tokens and those that they have been approved to use.
 * add a on-off modifier to enable/disable burn
 * _Available since v3.1._
 */
    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public virtual whenBurnEnabled {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "BaokuNFT: caller is not token owner or approved"
        );

        _burn(account, id, value);
    }


    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) public virtual whenBurnEnabled() {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "BaokuNFT: caller is not token owner or approved"
        );

        _burnBatch(account, ids, values);
    }

    function enableBurn() public virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        _enableBurn();
    }

    function disableBurn() public virtual onlyRole(DEFAULT_ADMIN_ROLE){
        _disableBurn();
    }


}