pragma solidity ^0.5.0;

import "./ICFX88.sol";
import "./SafeMath.sol";

contract CFX88 is ICFX88 {
    using SafeMath for uint256;

    mapping (uint256 => address) private _tokenOwner;
    mapping (uint256 => address) private _tokenApprovals;
    mapping (address => uint256) private _ownedTokensCount;
    
    string public name;
    string public symbol;
    address public creator;
    
    constructor () public {
        name = "Conflux 88";
        symbol = "CFX88";
        creator = msg.sender;
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "CFX88: balance query for the zero address");

        return _ownedTokensCount[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "CFX88: owner query for nonexistent token");

        return owner;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "CFX88: transfer caller is not owner nor approved");
        _transferFrom(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(msg.sender, tokenId), "CFX88: transfer caller is not owner nor approved");

        _transferFrom(from, to, tokenId);
    }
    
    function approve(address to, uint256 tokenId) public {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0) && to != owner, "CFX88: invalid receiver or nonexistent token");
        require(msg.sender == owner, "CFX88: approve caller is not owner");

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "CFX88: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }
    
    // Internal functions
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "CFX88: owner query for nonexistent token");
        return (spender == owner || getApproved(tokenId) == spender);
    }

   function _mint(address to, uint256 tokenId) internal {
        require(to != address(0) || _tokenOwner[tokenId] == address(0), "CFX88: cannot mint new token");
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to] + 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(address burner, uint256 tokenId) internal {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0) && owner == burner, "CFX88: unable to burn token");

        _clearApproval(tokenId);

        _ownedTokensCount[owner] = _ownedTokensCount[owner] - 1;
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

    function _burn(uint256 tokenId) internal {
        
        require(creator != msg.sender, "CFX88: only creator can burn token");
        address owner = _tokenOwner[tokenId];
        _burn(owner, tokenId);
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0) && owner == from, "CFX88: transfer of token that is not owned");
        require(to != address(0), "CFX88: transfer to the zero address. Pls burn instead.");

        _clearApproval(tokenId);

        _ownedTokensCount[from] = _ownedTokensCount[from] - 1;
        _ownedTokensCount[to] = _ownedTokensCount[to] + 1;

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}
