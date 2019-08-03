//pragma solidity ^0.5.0; //solidity version
pragma solidity ^0.4.24;

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
        address owner; //this was previously address payable but The payable modifier for addresses is only available from solc v0.5.xx
        string name;
        string image; //url to the image
        bool sold;
    }

    /**
    *  @dev state variables
    */
    //uint8 NUM_TOKENS_TO_MINT = 100; //number of tokens (pairs of shoes) to mint on deployment of contract

    //100 tokens is causing out of gas exception, 25 tokens uses 7673544 gas (limit is approx 8000000),
    // set gas limit in Ganache to 0x2FEFD800000 i.e. 3294197972992 and gas price to 200000000000000
    // then cost of deploy for 100 tokens is 21526736
    uint8 constant NUM_TOKENS_TO_MINT = 100;


    uint8 shoesSold = 0; //number of shoes sold
    uint8 constant ETHER_WEI_CONST = 10^18; // 1 ether = 1000000000000000000 wei
    uint64 constant PRICE = (1 ether / 2) * ETHER_WEI_CONST; //price in wei

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
    * ERC721Token(_name, _symbol) is required in OpenZeppelin implementation. _name and _symbol set in migration script
    */
    constructor (string _name, string _symbol) ERC721Token(_name, _symbol) public {
        //set minter to Ethereum address that deployed the contract
        minter = msg.sender;

        //mint 100 tokens
        createShoePair(minter);
    }

    /**
    * @dev A function to create 100 shoe pairs (i.e. 100 tokens).
    * The owner of each token is the address deploying the contract (msg.sender),
    * name and image are empty strings( “” ), and sold is equal to false.
    * Add the pair to the array of shoes.
    * @param _to address of future owner of the token
    */
    function createShoePair(address _to) private {
        string memory _tokenURI = "CoShoe Token";
        for (uint _tokenId = 0; _tokenId < NUM_TOKENS_TO_MINT; _tokenId++) {

            //create new pair of shoes, push to array and return position
            shoes.push(Shoe(_to, "", "", false));

            // trigger registeredShoe event
            emit registeredShoeEvent(_tokenId);

            // Create unique token by calling Open-Zeppelin function
            super._mint(_to, _tokenId);
            super._setTokenURI(_tokenId, _tokenURI);
        }
    }

    /**
    * @dev A function to buy shoes and increment shoesSold
    * Takes the input parameters name, image.
    * Checks that there is still a pair of shoes left that has not been sold yet, otherwise it throws an error.
    * Checks that the value that is attached to the function call equal the price , otherwise it throws an error.
    * Transfers the ownership of a Shoe to the caller of the function by setting owner within the Shoe struct,
      setting name and image to the input variables, and changing sold to true.
    * @param _name address of future owner of the token
    * @param _image address of future owner of the token
    */
    function buyShoe(string _name, string _image) public payable{
        require((NUM_TOKENS_TO_MINT - shoesSold) <= 1, 'No pair of shoes left');
        require(msg.value != PRICE, 'Proposed price does not match price of shoes');

        uint shoeIndex = shoesSold; //shoesSold starts at 0
        uint buyerSendAmount = msg.value; //number of wei sent with the message
        address buyerAddress = msg.sender; //sender of the message (current call)

        //Shoe memory shoeToBuy = shoes[shoeIndex];
        address previousOwner = shoes[shoeIndex].owner;
        previousOwner.transfer(buyerSendAmount); //transfer money to previous owner
        shoes[shoeIndex].owner = buyerAddress;
        shoes[shoeIndex].name = _name;
        shoes[shoeIndex].image = _image;
        shoes[shoeIndex].sold = true;
        shoesSold += 1;
    }

    /**
    * @dev A function that returns an array of bools that are set to true if the equivalent index in shoes belongs to caller of this function
    * Example: [true, false, false, false, false, true, false, false, …]
    * Function implemented in a gas saving manor
    */
    function checkPurchases() public view returns(bool[]) {
        uint shoeArrayLength = this.getNumberOfRegisteredShoes();
        bool[] memory shoeBoolArray = new bool[](shoeArrayLength);
        bool shoeBoolArrayItem;
        for (uint i = 0; i < shoeArrayLength; i++) {
            if (shoes[i].owner == msg.sender){
                shoeBoolArrayItem = true;
            }
            else{
                shoeBoolArrayItem = false;
            }
            shoeBoolArray[i] = shoeBoolArrayItem;
        }
        return shoeBoolArray;
    }


    /**
    * @dev A function to get the number of shoes registered / tokens minted i.e. length of shoes array
    */
    function getNumberOfRegisteredShoes () external view returns(uint) {
        return shoes.length;
    }
}
