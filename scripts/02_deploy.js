const { ethers } = require("hardhat");
const hre = require("hardhat");
const fs = require("fs");

async function main() {
  console.log("Deploying eBookNFT contract for the project");
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  const balance = await deployer.getBalance();
  console.log("Account balance:", balance.toString());

  // deploy the NFT_ebook
  const Ebook_contract = await hre.ethers.getContractFactory("eBookNFT");
  const ebook = await Ebook_contract.deploy();

  await ebook.deployed();

  console.log("Ebook Contract address:", ebook.address);

  const dataEbook = {
    address: ebook.address,
    abi: JSON.parse(ebook.interface.format('json'))
  }

  //This writes the ABI and address to the mktplace.json
  fs.writeFileSync('./src/eBookNFT.json', JSON.stringify(dataEbook))  

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
