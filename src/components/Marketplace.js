import Navbar from "./Navbar";
import NFTTile from "./NFTTile";
import MarketplaceJSON from "../eBookMarketplace.json";
import axios from "axios";
import { useState } from "react";
import bandeau from '../bandeau.png';

export default function Marketplace() {
const sampleData = [

];
const [data, updateData] = useState(sampleData);
const [dataFetched, updateFetched] = useState(false);

async function getAllNFTs() {
    const ethers = require("ethers");
    //After adding your Hardhat network to your metamask, this code will get providers and signers
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    //Pull the deployed contract instance
    let contract = new ethers.Contract(MarketplaceJSON.address, MarketplaceJSON.abi, signer)
    //create an NFT Token
    let transaction = await contract.getAllItems()

    // get all the details of every NFT from the contract and display
    const items = await Promise.all(transaction.map(async i => {
        let meta = await axios.get(i.tokenURI);
        meta = meta.data;

        let price = ethers.utils.formatUnits(i.price.toString(), 'ether');
        let item = {
            price,
            tokenId: i.tokenId.toNumber(),
            seller: i.seller,
            owner: i.owner,
            image: meta.image,
            name: meta.name,
            description: meta.description,
        }
        return item;
    }))

    updateFetched(true);
    updateData(items);
}

if(!dataFetched)
    getAllNFTs();


return (
    <div>
        <Navbar></Navbar>
        
            <img src={bandeau} alt="" width={1000} className="center-bandeau"/>
        
        <div className="flex flex-col place-items-center mt-20 ml-240">
            
            <div className="md:text-xl font-bold text-white">
                Our e-book collection 
            </div>
            <div className="flex mt-5 justify-between flex-wrap max-w-screen-xl text-center">
                {data.map((value, index) => {
                    return <NFTTile data={value} key={index}></NFTTile>;
                })}
            </div>
        </div>            
    </div>
);

}
