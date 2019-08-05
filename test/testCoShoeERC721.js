const truffleAssert = require('truffle-assertions');

// import the contract artifact
const CoShoe = artifacts.require('CoShoe');

//we always have 10 accounts in local ganache env

contract (CoShoe, function (accounts) {
    //predefine parameters
    const token_name = "CoShoeToken";
    const token_symbol = "CoShoeTokenSymbol";
    const minter = accounts[0];
    const account1 = accounts[1];
    const account2 = accounts[2];
    const half_ether = web3.utils.toWei('0.5', 'ether');
    const quarter_ether =web3.utils.toWei('0.25', 'ether');


// a.100 tokens are minted on deployment
// b. buyShoe correctly transfers ownership, sets the name and the image, sets sold, and updates soldShoes count
// c. buyShoe reverts if the price is not equal to 0.5 ether
// d. checkPurchases returns the correct number of true's

    it('Deploy contract, mint tokens and confirm token name and symbol are correct', async () => {
        CoShoeInstance = await CoShoe.new(token_name, token_symbol);
        expect(await CoShoeInstance.symbol()).to.equal(token_symbol);
        expect(await CoShoeInstance.name()).to.equal(token_name);
    });

    // a.100 tokens are minted on deployment
    it('100 ERC721 tokens are minted on deployment', async () => {
        expect(Number(await CoShoeInstance.totalSupply())).to.equal(100);
    });

     // b. buyShoe correctly transfers ownership, sets the name and the image, sets sold, and updates shoesSold count
    it('buyShoe correctly transfers ownership, sets the name and the image, sets sold, and updates soldShoes count', async () => {
        let shoeName = 'Airforce1';
        let shoeUrl = 'http://helloworld';
        let shoePrice = await CoShoeInstance.getPrice();

        console.log("half_ether " +half_ether);
        console.log("half_ether from solidity " + shoePrice);
        await CoShoeInstance.buyShoe(shoeName, shoeUrl, {from: account1, value: half_ether});

        // retrieve the details for the pair of shoes
        let shoePair = await CoShoeInstance.shoes(0);

        // check that the ownership was correctly transferred
        assert.equal(shoePair['owner'], account1, 'owner does not match');

        // check that the name of the shoes was correctly set
        assert.equal(shoePair['name'], shoeName, 'name of the shoes was correctly set');

        // check that the image of the shoes was correctly set
        assert.equal(shoePair['image'], shoeUrl, 'image of the shoes was not correctly set');

        // check that the sold attribute was correctly set
        assert.equal(shoePair['sold'], true, 'sold attribute was not correctly set');

        // check that the shoesSold count was correctly updated
        let shoesSoldCounter = await CoShoeInstance.getNumShoesSold();
        assert.equal(shoesSoldCounter, 1, 'shoesSold was not correctly updated');
    });

     // c. buyShoe reverts if the price is not equal to 0.5 ether
    it('buyShoe reverts if the price is not equal to 0.5 ether', async () => {
        let shoeName = 'Airforce1';
        let shoeUrl = 'http://helloworld';

        await truffleAssert.reverts(CoShoeInstance.buyShoe(shoeName, shoeUrl, {from: account1, value: quarter_ether}));
    });

     // d. checkPurchases returns the correct number of true's (we expect 1 true and 99 false)
    it('checkPurchases returns the correct number of trues for account1', async () => {
        let shoePurchaseArray = await CoShoeInstance.checkPurchases({from: account1});
        let numTrues = shoePurchaseArray.filter(c => c ===true).length;
        assert.equal(numTrues, 1, 'checkPurchases was not correctly updated');
    });

    it('Length of shoes array is 100 on deployment', async function () {
        // fetch instance of CoShoe contract
        //let CoShoeInstance = await CoShoe.deployed()
        // get the number of shoes pairs / tokens initially
        let shoePairCounter = await CoShoeInstance.getNumberOfRegisteredShoes();
        // check that there are 100 shoes pairs (i.e. same as tokens initially)
        assert.equal(shoePairCounter, 100, 'initial number of shoe pairs not equal to 100');
      });
});