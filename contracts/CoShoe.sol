pragma solidity ^0.5.0; //solidity version

//Contract 
contract CoShoe is ERC721 {

    // The keyword public makes the variable readable from outside of the contract.
    address public minter;

    /*a shoe struct holding the shoe’s owner (address), name (string),
    an image (url where it can be downloaded), sold  (boolean) */
    struct Shoe {
        address payable owner;
        string name;
        string image; //url to the image
        bool sold;
    }
    //state variables
    uint price = 0.5/(1 ether); //ether converted to wei
    uint shoesSold = 0; //number of shoes sold
    uint numTokensToMint = 100; //number of tokens to mint on deployment of contract

    Shoe[] public shoes;  //array of shoes made public because I have length method

    constructor () public {
        //set minter to Ethereum address that deployed the contract
        minter = msg.sender;

        //create 100 tokens
        for (uint i = 0; i < numTokensToMint; i++) {
        createShoePair(minter);
        }
    }

    /**
    * @dev An event for lightweight clients when a new shoe is created.
    */
    event registeredShoeEvent (
        uint indexed _shoeId
    );

    /**
    * @dev A function to create a new shoe pair (i.e. a token).
    * The owner of each token is the address deploying the contract (msg.sender),
    * name and image are empty strings( “” ), and sold is equal to false.
    * Add the pair to the array of shoes.
    * @param _to address of future owner of the token
    */
    function createShoePair(address _to) public {
        //create new pair of shoes, push to array and return position
        uint id = (shoes.push(Shoe(_to, "", "", false)))-1;

        // trigger registeredShoe event
        emit registeredShoeEvent(id);

        // Assign token to the Ethereum Address that deployed the contract i.e minter
        _mint(_to, id);
    }

    /**
    * @dev A function to get the number of shoes registered i.e. length of shoes array
    */
    function getNumberOfRegisteredShoes () external view returns(uint) {
        return shoes.length;
    }
}
