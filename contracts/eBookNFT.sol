//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract eBookNFT is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //set the price to mint each NFT
    uint256 private price = 0.01 ether;

    //set the max supply of NFT's
    uint256 private maxSupply = 100;

    // actual balance on this contract 
    uint private balance;

    /* The structure to store info about our ebook */
    struct Characteristics {
        bool isPromotor;
    }

    Characteristics[] ebookNFTTable;

    // @notice the list of events 
    event evtMinted(uint tokenId); 
    event evtNewPrice(uint newPrice);
    event evtNewSupply(uint maxSupply);

    constructor() ERC721("ENCYCLOPEDISTS_NFT","NFT") {}

    /// @notice Mint a new ebook 
    /// @dev public function 
    /// @param _userAddress user address
    /// @param _tokenURI metadata link 
    /// @param _isPromotor set to true if this is a promotor reader
    /// @return newTokenID the new token ID
    function MintEbook (address _userAddress, string calldata _tokenURI, bool _isPromotor) public payable returns(uint)
    {
        require(ebookNFTTable.length < (maxSupply - 1), "All NFT has been sold");
        require(msg.value >= price, "Please send more money");
        if (_tokenIds.current() == 0 ) {
            // First NFT can only be minted by the owner ... that's the rule ;-)
            _checkOwner();
        }

        // we start at 1
        _tokenIds.increment(); 

        uint newTokenID = _tokenIds.current();

        // store in array 
        ebookNFTTable.push(Characteristics(_isPromotor));

        // let's mint it 
        _mint(_userAddress, newTokenID);

        // set link to metadata
        _setTokenURI(newTokenID, _tokenURI);

        // increase balance   TODO check security here ! 
        balance += msg.value;

        // emit event 
        emit evtMinted(newTokenID);

        return newTokenID;
    }

    // @notice set the price of an NFT
    // @dev Could only be called by the Owner
    // @param _newPrice the new price
    function setPrice(uint256 _newPrice) public onlyOwner {
        require(_newPrice != 0, "The price could not be zero" );
        
        price = _newPrice;

        // emit event 
        emit evtNewPrice(_newPrice);
    }

    // @notice set the number of available NFT in this collection 
    // @dev Could only be called by the Owner
    // @param _maxSupply number of NFT that can be minted
    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        require(ebookNFTTable.length < _maxSupply, "max supply should higher than the number of minted NFT" );
        require(_maxSupply != 0, "Max supply could not be zero" );
        
        maxSupply = _maxSupply;
        
        // emit event 
        emit evtNewSupply(_maxSupply);
    }
   
    // @notice Check actual balance on this contract  
    // @dev Could only be called by the Owner
    // @return the actual balance 
    function withdraw() public payable onlyOwner {
        // no reentrency issue here
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    // @notice Check actual balance on this contract  
    // @dev Could only be called by the Owner
    // @return the actual balance 
    function getBalance() public view returns(uint256) {
        uint256 retAddress = balance;
        return retAddress;
    }

}
