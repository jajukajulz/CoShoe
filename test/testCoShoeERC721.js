// import the contract artifact
const CoShoe = artifacts.require('CoShoe')

//we always have 10 accounts in local ganache env

contract (CoShoe, function (accounts) {
    //predefine parameters
    const token_name = "CoShoeToken";
    const token_symbol = "CoShoeTokenSymbol";


// a.100 tokens are minted on deployment
// b. buyShoe correctly transfers ownership, sets the name and the image, sets sold, and updates soldShoes count
// c. buyShoe reverts if the price is not equal to 0.5 ether
// d. checkPurchases returns the correct number of true's

    it('Deploy contract, mint tokens and confirm token name and symbol are correct', async () => {
        CoShoeInstance = await CoShoe.new(token_name, token_symbol)
        expect(await CoShoeInstance.symbol()).to.equal(token_symbol)
        expect(await CoShoeInstance.name()).to.equal(token_name)
    })

    // a.100 tokens are minted on deployment
    it('100 ERC721 tokens are minted on deployment', async () => {
        expect(Number(await CoShoeInstance.totalSupply())).to.equal(100)
    })

    it('Length of shoes array is 100 on deployment', async function () {
        // fetch instance of CoShoe contract
        //let CoShoeInstance = await CoShoe.deployed()
        // get the number of shoes pairs / tokens initially
        let shoePairCounter = await CoShoeInstance.getNumberOfRegisteredShoes()
        // check that there are 100 shoes pairs (i.e. same as tokens initially)
        assert.equal(shoePairCounter, 100, 'initial number of shoe pairs not equal to 100')
      })
})