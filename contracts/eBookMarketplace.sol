//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "./eBookFactory.sol";
import "./eBookNFT.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract eBookMarketplace is Ownable, eBookFactory {

    using Counters for Counters.Counter;
    //_tokenIds variable has the most recent minted tokenId
    Counters.Counter private _tokenIds;
    // total number of items sold on the marketplace
    Counters.Counter private _itemsTotal;

    // NFT instance 
    eBookNFT ebook_nft_instance;

    //The fee charged by the marketplace to be allowed to list an NFT
    uint256 listPrice = 0.01 ether;

    // The structure to store info about a listed token
    // this structure is overkill !!! 
    // i.e. tokenURI should be retrieved directly from the smartcontract eBookNFT (this is just a shortcut for the demo)
    struct ListedCollection {
        address contract_eBookNFTAddress;
        string  tokenURI;
        uint256 remainingMint; 
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }

    //the event emitted when Author is publishing an eBook
    event evtPublishSuccess(
        address collectionAddress,
        address owner,
        address seller,
        uint256 price
    );

    // event in case of receive or fallback 
    event evtReceiveOrFallback(address userAddress);

    //This mapping maps collectionId to token info and is helpful when retrieving details about a tokenId
    mapping(uint256 => ListedCollection) private idToListedCollection;

    constructor()  {
       
    }

    function getListedTokenForId(uint256 tokenId) public view returns (ListedCollection memory) {
        return idToListedCollection[tokenId];
    }

    // The Author publish an eBook collection  
    // @param eBookTitle title of the eBook
    // @param tokenURI json with the meatadat
    // @param price list price for this collection
    // @return address of the smart contract collection
    function createCollection_eBook(string memory eBookTitle, string memory tokenURI, uint256 price) public payable returns (address) {
        require(price > 0, "A collection should have a price");

        address collectionAddress;
        uint itemCount;
    
        // call the Factory to create the collection and retrieve address - title is for the nonce
        collectionAddress = factoryCreateNFTCollection(eBookTitle);

        // get an instance from contract address 
        ebook_nft_instance = eBookNFT(collectionAddress);

        //Mint the NFT with tokenId newTokenId to the address who called createToken
        uint newTokenId = ebook_nft_instance.mint_publish_eBook (tokenURI);    
        
        _itemsTotal.increment(); 

        itemCount = _itemsTotal.current();

        // set max supply - should come from the Author 
        ebook_nft_instance.setMaxSupply(100);

        // set the collection price 
        ebook_nft_instance.setPrice(price);

        // we have to transfert ownership to the Author 
        // ebook_nft_instance.transferFrom(address(this), msg.sender, newTokenId);

        // approve the marketplace to sell NFTs on your behalf
        // ebook_nft_instance.approve(address(this), newTokenId);
        
        uint remainingBook = ebook_nft_instance.getRemainingMinting();

        // create a list with the collection (and all needed stuff for fron-end) ... again a bit overkill ;-) but easier
        createListedeBook(collectionAddress, newTokenId, itemCount, price, tokenURI, remainingBook);

        return collectionAddress;
    }

    // Create a list with the total number of items on the marketplace ... again a bit overkill ;-) but easier
    // @param _collectionAddress collection address
    // @param _tokenId the token ID created at the collection address
    // @param _itemCount total items on the marketplace (to mint or buy)
    // @param price list price for this collection
    // @param tokenURI json with the meatadat
    // @param _remainingMintBook number of minting still possible in this collection
    // @return address of the smart contract collection
    function createListedeBook(address _collectionAddress, uint _tokenId, uint _itemCount, uint _price, string memory _tokenURI, uint _remainingMintBook) private {
        require(_price > 0, "A collection should have a price");

        // Update the collection mapping of _itemsTotal to the NFT details
        idToListedCollection[_itemCount] = ListedCollection(
            _collectionAddress,
            _tokenURI,
            _remainingMintBook,
            _tokenId,
            payable(address(this)),
            payable(msg.sender),
            _price,
            true
        );

        // _transfer(msg.sender, address(this), tokenId);

        // Emit the event for successful transfer. 
        emit evtPublishSuccess(
            _collectionAddress,
            address(this),
            msg.sender,
            _price
        );
    }
    
    // This will return all items currently listed to be sold or minted on the marketplace
    function getAllItems() public view returns (ListedCollection[] memory) {
        // parse all contracts 

        uint nftCount = _itemsTotal.current();
        ListedCollection[] memory tokens = new ListedCollection[](nftCount);
        uint currentIndex = 0;
        uint currentId;
        //at the moment currentlyListed is true for all, if it becomes false in the future we will 
        //filter out currentlyListed == false over here
        for(uint i=0;i<nftCount;i++)
        {
            currentId = i + 1;
            ListedCollection storage currentItem = idToListedCollection[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        //the array 'tokens' has the list of all NFTs in the marketplace
        return tokens;
    }
    
    // Get all NFT from the current user (to buy / sell )
    // @return a table of struct ListedCollection[]
    function getMyNFTs() public view returns (ListedCollection[] memory) {
        uint totalItemCount = _itemsTotal.current();
        uint itemCount = 0;
        uint currentIndex = 0;
        uint currentId;

        // get number of user NFTs to make an array  
        for(uint i=0; i < totalItemCount; i++)
        {
            if(idToListedCollection[i+1].owner == msg.sender || idToListedCollection[i+1].seller == msg.sender){
                itemCount += 1;
            }
        }

        // create an array to store all NFTs
        ListedCollection[] memory items = new ListedCollection[](itemCount);
        for(uint i=0; i < totalItemCount; i++) {
            if(idToListedCollection[i+1].owner == msg.sender || idToListedCollection[i+1].seller == msg.sender) {
                currentId = i+1;
                ListedCollection storage currentItem = idToListedCollection[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    // Execute a sale ...
    // @param tokenItem  the item in the marketplace we are selling 
    function executeSale(uint256 tokenItem) public payable {
        // retrieve contract address 
        address contractNFT = idToListedCollection[tokenItem].contract_eBookNFTAddress;
        uint price = idToListedCollection[tokenItem].price;
        address seller = idToListedCollection[tokenItem].seller;
        require(msg.value == price, "Please check amount to complete the purchase");

        //update the details of the token
        idToListedCollection[tokenItem].currentlyListed = true;
        idToListedCollection[tokenItem].seller = payable(msg.sender);

        // get an instance from contract address 
        ebook_nft_instance = eBookNFT(contractNFT);

        uint tokenId = idToListedCollection[tokenItem].tokenId;

        // extract the real owner of the tokenId
        address ownerNFT=ebook_nft_instance.ownerOf(tokenId);

        //Actually transfer the token to the new owner
        ebook_nft_instance.transferFrom(ownerNFT, msg.sender, tokenId);

        //approve the marketplace to sell NFTs on your behalf
        // ebook_nft_instance.approve(address(this), tokenId);

        //Transfer the listing fee to the marketplace creator
        //payable(owner).transfer(listPrice);

        //Transfer the proceeds from the sale to the seller of the NFT
        // payable(seller).transfer(msg.value);
    }

    // @notice Check actual balance on this contract  
    // @dev Could only be called by the Owner
    // @return the actual balance 
    function withdraw() public payable onlyOwner {
        require(address(this).balance > 0, "no balance to retrieve");
        // no reentrency issue here
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    // @notice needed to receive money 
    receive() external payable {
        emit evtReceiveOrFallback(msg.sender);
    }

    // @notice fallback 
    fallback() external payable {
        emit evtReceiveOrFallback(msg.sender);
    }

}
