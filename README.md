# The ENCYCLOPEDISTS Marketplace

A publishing platforme open to everyone 

This application use : 
* Event and useEffect, and components 
* display the connected metamask address, 
* display if you are the owner ...  eleven appears = she has all the power ;-)
* display if you are the voters ... = the bad guys, you will see the monster in the bottom of the page 
* Display the list of all voters 
* Display the list of proposal 
* Enable / Display buttons, inputs following who you are
* some internal test are also done checksum and alert on address, etc ... 

You can also test the deployed version on vercel here : 
## Getting started 

First, see the video tutorial here : 

## Directories (some important files)
```
├── truffle - contracts =>   the contracts with added comments 
├── truffle - 
└─── client - src 
              ├── App.jsx    
              └── components 
                     ├── LogoST.jsx :  
                     └─── Web3stuff
                              ├── Address.jsx : 
                              ├── Button.jsx : 
                              ├── ButtonAddSequence.jsx : 
                              ├── ButtonAddVoter.jsx : 
                              ├── ButtonProposal.jsx : 
                              └── index.jsx : 
```                              

## Requirements 

* ganache 
* Solidity 0.8.13
* vercel (with Node in version 16.x )
Please change the node version on vercel : 
https://vercel.com/changelog/node-js-version-now-customizable-in-the-project-settings


## Usage Localhost : 

First run ganache (with mnemonics from your test wallet)
```
ganache
```

## Deploy on testnet Goerli 
```
npx hardhat run --network goerli scripts/deploy.js
```

## Result

Here is a screnshot of the application 

## Usage vercel 

## contract owner address on Goerli testnet 
```
Owner address

Smart contract address

```
See on etherscan : 