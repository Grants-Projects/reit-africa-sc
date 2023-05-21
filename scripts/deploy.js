// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
require("dotenv").config();

async function main() {
  const [deployer] = await ethers.getSigners()
  console.log("deployer", deployer)
  console.log('Deploying contracts with the account:', deployer.address)
  console.log('Account balance:', (await deployer.getBalance()).toString())


  //Deploy ReitAfrica
  const ReitAfrica = await ethers.getContractFactory('ReitAfrica');
  const reitAfricaContract = await ReitAfrica.deploy();

  console.log("address for reit africa", reitAfricaContract.address)


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
