
const { expect } = require('chai');
const { ethers } = require("hardhat");

// Test our smart contrcat
describe('eBookNFT', function () {
  before(async function () {
    this.eBookContract = await ethers.getContractFactory('eBookNFT');
  });

  beforeEach(async function () {
    // deploy the contract
    this.eBookContract = await this.eBookContract.deploy();
    await this.eBookContract.deployed();

    // Get the contractAuthor and readerPromotor (we get royalties as well) address
    const signers = await ethers.getSigners();
    this.contractAuthor = signers[0].address;
    this.readerPromotor = signers[1].address;

    // Get the readerPromotor contract for signing transaction with readerPromotor key
    this.collectorContract = this.eBookContract.connect(signers[1]);

    this.initialMint = [];

    // Mint an initial set of NFTs from this collection
    await this.eBookContract.mint_publish_eBook(tokenURI);   
  });

  // Test cases
  it('Check Author is the owner of the first minted token', async function () {
    tokenID = 1;
    expect(await this.eBookContract.ownerOf(tokenID)).to.equal(this.contractAuthor);
  });

  it('Check we can query the balance', async function () {
    tokenQty = 1;
    expect(await this.eBookContract.balanceOf(this.contractAuthor)).to.equal(tokenQty);
  });

  it('check a promotor can mint a new eBook', async function () {
    let tokenId = 2;
    await this.eBookContract.mintNexteBook(this.readerPromotor);
    expect(await this.eBookContract.ownerOf(tokenId)).to.equal(this.readerPromotor);
  });

  it('can transfer eBook to another when called by owner', async function () {
    let tokenId = 1;
    await this.eBookContract["safeTransferFrom(address,address,uint256)"](this.contractAuthor, this.readerPromotor, tokenId);
    expect(await this.eBookContract.ownerOf(tokenId)).to.equal(this.readerPromotor);
  });

  /* To continue */
  
});



