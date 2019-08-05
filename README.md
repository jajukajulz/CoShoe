# CoShoe
CoShoe is an Ethereum smart contract that holds non-fungible tokens (ERC-721) that represent a pair of shoes. Each pair of shoes are unique (personalised - buyer can choose name at the back and image on the side; public key of buyer is engraved into the sole.
Every ERC-721 compliant contract must implement the ERC721 and ERC165 interfaces as below.
```
interface ERC721 /* is ERC165 */ {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
    }
                                            
interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}
```
The interfaces are implemented in the `zeppelin-solidity` package and `CoShoe` inherits from `ERC721Token` i.e. don't re-invent the wheel!
    
## Installation
1. Install Truffle globally. Truffle is the most popular smart contract development, testing, and deployment framework. 
```
$npm install -g truffle 
```

2. Start Ganache and Create a Workspace (or open an existing one). Since we are minting 100 tokens in the constructor, you will need to create a Ganache Workspace with the following parameters to avoid an out of gas exception.
```
Gas Limit 3294197972992 
Gas price 200000000000000
```

3. Install npm dependencies.
```
$ npm install
```

4. Confirm CoShoe smart contract compiles successfully.
```
$truffle compile
```

5. Run tests for CoShoe smart contract.
```
$truffe test
$truffle test --network development
```

6. Deploy CoShoe smart contract to Ganache (assumes Ganache is running).

`truffle migrate` will run all migrations located within your project's migrations directory. If your migrations were previously run successfully, truffle migrate will start execution from the last migration that was run, running only newly created migrations. If no new migrations exists, `truffle migrate` won't perform any action at all. 
```
$truffle migrate
```

The --reset flag will force to run all your migrations scripts again. Compiling if some of the contracts have changed. You have to pay gas for the whole migration again. 
```
$truffle migrate --reset
```

The --all flag will force to recompile all your contracts. Even if they didn't change. It is more time compiling all your contracts, and after that it will have to run all your deploying scripts again.
```
$truffle migrate --compile-all --reset
```

If for some reason truffle fails to acknowledge a contract was modified and will not compile it again, delete the build/ directory. This will force a recompilation of all your contracts and running all your deploy scripts again.

7. Update `truffle-config.js` development network with NetworkID, Host and Port values from your local Blockchain in Ganache.


## Other
1. Access deployed contract from CLI
```
$ truffle console
$ CoShoe.deployed().then(function(instance) { app = instance })
$ app.getNumberOfRegisteredShoes()
```

2. Add a new migration
```
$touch 2_deploy_contract.js
```

3. Create infura project  at https://infura.io (Infura gives you access to test network).
This project will give you an ID that you will use in `truffle-config.js`
infura means you do not have to sync an ether node or rinkeby node to deploy directly.

4. Get test ether from https://faucet.rinkeby.io/ (you will need to create an Ethereum rinkeby wallet on MetaMask then use the address on twitter).
e.g. 0x4B67D20a4F27d248aF0462C23F8C193f073517FB

5. Update `truffle-config.js` with rinkeby. This will deploy from the metamask accounts, by default account 0 so specify which one you want.

6. Deploy to rinkeby. 
```
$truffle migrate --network rinkeby --compile-all --reset
```

7. Check contract on rinkeby etherscan https://rinkeby.etherscan.io

