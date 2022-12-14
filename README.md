# The ENCYCLOPEDISTS Marketplace

A decentralized publishing platforme open to everyone !

This is my first real experience with javascript, react and solidity ... I'm proud to have made it !

This application can :
- An Author can publish a new eBook collection (The first eBook is minted) (Note : max supply is fixed at 100 eBooks)
- Metadata are uploaded to pintata / ipfs (With a picture cover + a pdf with the eBook (content))
- Readers can mint the collection up to the Max supply
- The Marketplace can display all eBooks for sell (By default all eBook can be sell)

Note : there is a lot of space for improvement ;-) 
The marketplace keeps a mapping and counter with all items, this should be replaced by listening to event ("evtMinted"), etc ...

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

For testing 
* $ npm install --save-dev chai
* $ npm install --save-dev @nomicfoundation/hardhat-chai-matchers

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
<img width="1628" alt="image" src="https://user-images.githubusercontent.com/23697098/206937340-cb53aa52-65ba-410b-8602-5dcef1eba0a5.png">


## Vercel 

https://marketplace-encyclopedists.vercel.app/

