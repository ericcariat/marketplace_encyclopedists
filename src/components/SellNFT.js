import Navbar from "./Navbar";
import { useState } from "react";
import { uploadFileToIPFS, uploadJSONToIPFS } from "../pinata";
import Marketplace from '../eBookMarketplace.json';
import eBookNFT from '../eBookNFT.json';
import eBookFactory from '../eBookFactory.json';
import { useLocation } from "react-router";

export default function SellNFT () {
    const [formParams, updateFormParams] = useState({ name: '', description: '', price: ''});
    const [fileURL, setFileURL] = useState(null);
    const ethers = require("ethers");
    const [message, updateMessage] = useState('');
    const location = useLocation();
    const [fileURLeBook, setFile_eBookURL] = useState(null);

    // This function uploads the NFT image(cover) to IPFS
    async function OnChangeFile(e) {
        var file = e.target.files[0];
        //check for file extension
        try {
            //upload the file to IPFS
            const response = await uploadFileToIPFS(file);
            if(response.success === true) {
                console.log("Uploaded image to Pinata: ", response.pinataURL)
                setFileURL(response.pinataURL);
            }
        }
        catch(e) {
            console.log("Error during file upload", e);
        }
    }

    // This function uploads the eBook pdf to IPFS
    async function OnChangeFile_EBook(e) {
        var file = e.target.files[0];
        //check for file extension
        try {
            //upload the file to IPFS
            const response = await uploadFileToIPFS(file);
            if(response.success === true) {
                console.log("Uploaded ebook to Pinata: ", response.pinataURL)
                setFile_eBookURL(response.pinataURL);
            }
        }
        catch(e) {
            console.log("Error during ebook upload", e);
        }
    }
    
    //This function uploads the metadata to IPFS
    async function uploadMetadataToIPFS() {
        const {name, description, price} = formParams;
        //Make sure that none of the fields are empty
        if( !name || !description || !price || !fileURL || !fileURLeBook)
            return;

        const nftJSON = {
            name, description, price, image: fileURL, ebookLocation: fileURLeBook
        }

        try {
            //upload the metadata JSON to IPFS
            const response = await uploadJSONToIPFS(nftJSON);
            if(response.success === true){
                console.log("Uploaded JSON to Pinata: ", response)
                return response.pinataURL;
            }
        }
        catch(e) {
            console.log("error uploading JSON metadata:", e)
        }
    }

    async function publishNFTeBook(e) {
        e.preventDefault();

        //Upload data to IPFS
        try {
            const metadataURL = await uploadMetadataToIPFS();

            //After adding your Hardhat network to your metamask, this code will get providers and signers
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();

            updateMessage("Please wait.. publishing (upto 5 mins)")

            // Call the MaketPlace factory to deploy a new collection 
            let contract = new ethers.Contract(Marketplace.address, Marketplace.abi, signer)
            
            // get Author price 
            const price = ethers.utils.parseUnits(formParams.price, 'ether')
            
            //actually create the NFT
            let transaction = await contract.createCollection_eBook(formParams.name, metadataURL, price);
            await transaction.wait()

            alert("Successfully listed your NFT!");
            updateMessage("");
            updateFormParams({ name: '', description: ''});
            window.location.replace("/")
        }
        catch(e) {
            alert( "Upload error"+e )
        }
    }

    console.log("Working", process.env);
    return (
        <div className="">
        <Navbar></Navbar>
        <div className="flex flex-col place-items-center mt-10" id="nftForm">
            <form className="bg-[#101738] shadow-md rounded px-8 pt-4 pb-8 mb-4">
            <h3 className="text-center font-bold text-[#5e60ee] mb-8">Upload your book and cover to the marketplace</h3>
                <div className="mb-4">
                    <label className="block text-[#5e60ee] text-sm font-bold mb-2" htmlFor="name">Book name</label>
                    <input className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id="name" type="text" placeholder="MyTitle" onChange={e => updateFormParams({...formParams, name: e.target.value})} value={formParams.name}></input>
                </div>
                <div className="mb-6">
                    <label className="block text-[#5e60ee] text-sm font-bold mb-2" htmlFor="description">A short description</label>
                    <textarea className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" cols="40" rows="5" id="description" type="text" placeholder="MyDescription" value={formParams.description} onChange={e => updateFormParams({...formParams, description: e.target.value})}></textarea>
                </div>
                <div className="mb-6">
                    <label className="block text-[#5e60ee] text-sm font-bold mb-2" htmlFor="price">Price (in ETH)</label>
                    <input className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="number" placeholder="Min 0.01 ETH" step="0.01" value={formParams.price} onChange={e => updateFormParams({...formParams, price: e.target.value})}></input>
                </div>
                <div>
                    <label className="block text-[#5e60ee] text-sm font-bold mb-2" htmlFor="image">Upload Cover Image</label>
                    <input type={"file"} onChange={OnChangeFile}></input>
                </div>
                <br></br>
                <div>
                    <label className="block text-[#5e60ee] text-sm font-bold mb-2" htmlFor="image">Upload e-book</label>
                    <input type={"file"} name="text" onChange={OnChangeFile_EBook}></input>
                </div>
                <br></br>
                <div className="text-green text-center">{message}</div>
                <button onClick={publishNFTeBook} className="font-bold mt-10 w-full bg-[#918ef5] text-white rounded p-2 shadow-lg">
                    Publish your book
                </button>
            </form>
        </div>
        </div>
    )
}