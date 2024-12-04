pragma solidity ^0.4.24;

import "./ERC721.sol";

contract Item is ERC721 {
    struct GameItem {
        string name; // Name of the Item
        uint256 level; // Item Level
        uint256 rarityLevel; // 1 = normal, 2 = rare, 3 = epic, 4 = legendary
    }

    GameItem[] public items; // First Item has Index 0
    address public owner;
    uint tokenIndex;

    constructor() public {
        owner = msg.sender; // The Sender is the Owner; Ethereum Address of the Owner
    }

    mapping(address => bool) private _whitelisted;

    function createItem(string _name, address _to) public {
        require(owner == msg.sender); // Only the Owner can create Items
        uint256 id = items.length; // Item ID = Length of the Array Items
        items.push(GameItem(_name, 5, 1)); // Item ("Sword",5,1)
        _mint(_to, id); // Assigns the Token to the Ethereum Address that is specified
    }

    event ChangeOwner(address newOwner); 
    function changeOwner(address newOwner) public {
        require(newOwner != address(0), "owner invaild");
        require(msg.sender == owner);
        owner = newOwner;
        emit  ChangeOwner(newOwner);
        //声明所有者转变
    }

    function batchMintByOwner(address[] users, uint256[] tokenIds) public {
        require(owner==msg.sender);
        require(users.length == tokenIds.length, "length invaild");
        for (uint256 i = 0; i < users.length; i++) {
            _mint(users[i], tokenIds[i]);
        }
    }

    function mint() public payable {
        uint256 id = items.length; // Item ID = Length of the Array Items
        items.push(GameItem("name", 5, 1));
        _mint(msg.sender, tokenIndex++);//tokenId++
    }

    function mintByWhiteList() public {
        require(_whitelisted[msg.sender] == true, "no right");
        uint256 id = items.length; // Item ID = Length of the Array Items
        //items.push(GameItem("name", 5, 1));
        _mint(msg.sender, tokenIndex++);
    }

    function addWhiteList(address[] users) public {
        require(owner==msg.sender);
        for (uint256 i = 0; i < users.length; i++) {
            _whitelisted[users[i]] = true;
        }
    }

    function removeWhiteList(address[] users) public {
        for (uint256 i = 0; i < users.length; i++) {
            _whitelisted[users[i]] = false;
        }
    }

    function owner(address user) public view returns (uint256[]) {}
}
