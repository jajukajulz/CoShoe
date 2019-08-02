pragma solidity ^0.5.0; //solidity version

import "../node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

/**
 * @dev Implementation of ERC-721 non-fungible token standard.
 */
contract CoShoe is ERC721Token {

    /**
    *  @dev Ethereum address that deployed the contract. The keyword public makes the variable readable from outside of the contract.
    */
    address public minter;

    /**
    *  @dev Shoe struct holding the shoe’s owner (address), name (string),
    * an image (url where it can be downloaded), sold  (boolean)
    */
    struct Shoe {
        address payable owner;
        string name;
        string image; //url to the image
        bool sold;
    }

    /**
    *  @dev state variables
    */
    uint8 price = 0.5/(1 ether); //ether converted to wei
    uint8 numTokensToMint = 100; //number of tokens to mint on deployment of contract
    uint256 shoesSold = 0; //number of shoes sold
    string _tokenURI = "CoShoe Token";
    /**
    *  @dev Array of shoes. Made public because of length method.
    */
    Shoe[] public shoes;

    /**
    * @dev An event for lightweight clients when a new shoe is created.
    * @param _shoeId The NFT that got created.
    */
    event registeredShoeEvent (
        uint indexed _shoeId
    );

    /**
    * @dev Contract constructor.
    */
    constructor (string _name, string _symbol) public {
        //required in OpenZeppelin implementation
        ERC721Token(_name, _symbol);

        //set minter to Ethereum address that deployed the contract
        minter = msg.sender;

        //create 100 tokens
        for (uint i = 0; i < numTokensToMint; i++) {
        createShoePair(minter);
        }
    }

    /**
    * @dev A function to create a new shoe pair (i.e. a token).
    * The owner of each token is the address deploying the contract (msg.sender),
    * name and image are empty strings( “” ), and sold is equal to false.
    * Add the pair to the array of shoes.
    * @param _to address of future owner of the token
    */
    function createShoePair(address _to) public {
        //create new pair of shoes, push to array and return position
        uint256 _tokenId = (shoes.push(Shoe(_to, "", "", false)))-1;

        // trigger registeredShoe event
        emit registeredShoeEvent(_tokenId);

        // Create unique token by calling Open-Zeppelin function
        super._mint(_to, _tokenId);
        super._setTokenURI(_tokenId, _tokenURI);
    }

    /**
    * @dev A function to get the number of shoes registered i.e. length of shoes array
    */
    function getNumberOfRegisteredShoes () external view returns(uint) {
        return shoes.length;
    }
}
