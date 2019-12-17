pragma solidity ^0.5.0;

import "./SafeMath.sol";
import "./CFX88.sol";

contract PVHToken is CFX88 {
    using SafeMath for uint256;

    struct PVH{
        uint256 army;
        uint256 dragons;
        uint256 charm;
    }

    PVH[] public heroes;

    constructor () public {
        name = "Plain Vanilla Hero Token";
        symbol = "PVHT";
        creator = msg.sender;
    }

    function mint(uint256 _army, uint256 _dragons, uint256 _charm) public payable {
        require(creator == msg.sender, "PVHT: Only creator can mint tokens");
        PVH memory _pvh = PVH({army: _army, dragons: _dragons, charm: _charm});
        uint _pvhID = heroes.push(_pvh) - 1;
        _mint(msg.sender, _pvhID);
    }

    function burn(uint age, uint tokenId) public {
        require(age > 259200, "PVHToken: Hero has more life");
        _burn(msg.sender, tokenId);
    }
}
