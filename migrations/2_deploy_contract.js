const CoShoe = artifacts.require("./CoShoe.sol");

module.exports = async function(deployer) {
  await deployer.deploy(CoShoe, "CoShoeToken", "CoShoeTokenSymbol")
  const erc721 = await CoShoe.deployed()
};