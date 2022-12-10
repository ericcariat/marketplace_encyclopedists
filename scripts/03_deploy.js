const { ethers } = require("hardhat");
const hre = require("hardhat");
const fs = require("fs");

async function main() {
  console.log("Deploying eBookFactory contract for the project");
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  const balance = await deployer.getBalance();
  console.log("Account balance:", balance.toString());

  console.log("Deploying factory");

  const eBookFactoryContract = await hre.ethers.getContractFactory("eBookFactory");
  const eBookFactoryInstance = await eBookFactoryContract.deploy();

  await eBookFactoryInstance.deployed();

  console.log("eBookFactory Contract address:", eBookFactoryInstance.address);

  const dataFactory = {
    address: eBookFactoryInstance.address,
    abi: JSON.parse(eBookFactoryInstance.interface.format('json'))
  }

  //This writes the ABI and address to the json
  fs.writeFileSync('./src/eBookFactory.json', JSON.stringify(dataFactory))

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
