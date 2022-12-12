# The ENCYCLOPEDISTS Marketplace

A decentralized publishing platforme open to everyone !

This is my first real experience with javascript, react and solidity ... I'm proud to have made it !

This application use : 
* Event and useEffect, and components 
* display the connected metamask address, 
* display if you are the owner of the eBook + display the eBook for reading  
* display if you are a Reader = you can buy 
* Display the list of eBook to sell (by default all) 
* Enable / Display buttons, eBook following who you are

Note : On the web site, only the following menu are available 
- Marketplace : list all eBook on sale on this platforme 
- Publish : As an Author, you can publish your first eBook here 
- My profile : List all of your eBook + you can also read them 
## Getting started 

First, see the video tutorial here : 
https://www.loom.com/share/7b1bb6c02378439ab1961df58b26eefe

Github :
https://github.com/ericcariat/marketplace_encyclopedists

## Directories (some important files)
```
├── contracts => the 3 mains contracts : eBookFactory / eBookMarketplace / eBookNFT
├── scripts   => deployment scripts  
└───  src     -  components 
                     ├── Marketplace.js 
                     ├── Navbar.js 
                     ├── NFTpage.js  
                     ├── NFTTile.js 
                     ├── Profile.js 
                     └── SellNFT.js 
```                              

## Requirements 

* hardhat
* Solidity 0.8.13
* vercel (with Node in version 16.x )
Please change the node version on vercel : 
https://vercel.com/changelog/node-js-version-now-customizable-in-the-project-settings


## Usage Localhost : 

First run in a terminal : npx hardhat node

```
npx hardhat clean
npx hardhat compile
npx hardhat run --network localhost scripts/01_deploy.js
npx hardhat run --network localhost scripts/02_deploy.js
npm run start
```

## Deploy on testnet Goerli 
```
npx hardhat clean
npx hardhat compile
npx hardhat run --network goerli scripts/01_deploy.js
npx hardhat run --network goerli scripts/02_deploy.js
npm run start
```

## Result

Here is a screnshot of the application 

## Vercel 

https://marketplace-encyclopedists.vercel.app/

