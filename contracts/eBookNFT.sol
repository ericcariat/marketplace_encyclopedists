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
    uint256 private price = 0 ether;

    //set the max supply of NFT's
    uint256 private maxSupply = 100;

    // ceate a mapping to keep how many tokens each address has
    mapping(address => uint256) private ownedTokens;

    // keep the owner address for each tokenId
    mapping(uint256 => address) private tokenOwner;

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

    // @notice Publish a new eBook
    // @dev public function 
    // @param _userAddress user address
    // @param _tokenURI metadata link 
    // @param _isPromotor set to true if this is a promotor reader
    // @return newTokenID the new token ID
    // function mint_publish_eBook (string calldata _tokenURI, uint256 _newPrice, address _userAddress, bool _isPromotor) public payable onlyOwner returns(uint)
    function mint_publish_eBook (string calldata _tokenURI) public payable returns(uint)
    {
        require(ebookNFTTable.length < (maxSupply - 1), "All NFT has been sold");
        require(msg.value >= price, "Please send more money");

        // we start at 1
        _tokenIds.increment(); 

        uint newTokenID = _tokenIds.current();

        // store in array - keep if it is a promotor (for royalties later)
        // ebookNFTTable.push(Characteristics(_isPromotor));

        // let's mint it 
        _mint(msg.sender, newTokenID);

        // set link to metadata
        _setTokenURI(newTokenID, _tokenURI);

        // update our mapping 
        ownedTokens[msg.sender] +=1;
        tokenOwner[newTokenID] = msg.sender;

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

    // @notice get the list price 
    // @return the listed price 
    function getListPrice() public view returns (uint256) {
        return price;
    }

    // @notice set the number of available NFT in this collection 
    // @dev Could only be called by the Owner
    // @param _maxSupply number of NFT that can be minted
    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        require(_tokenIds.current() < _maxSupply, "max supply should higher than the number of minted NFT" );
        require(_maxSupply != 0, "Max supply could not be zero" );
        
        maxSupply = _maxSupply;
        
        // emit event 
        emit evtNewSupply(_maxSupply);
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

    // @notice Check actual balance on this contract  
    // @return the actual balance 
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // @notice get the remaining number of minting
    // @return number of NFT we can still mint in this contract 
    function getRemainingMinting() public view returns(uint) {
        require(maxSupply >= _tokenIds.current(), "we got a problem : tokenID > maxSupply");
        return (maxSupply - _tokenIds.current());
    }

    // @notice Check if an address is an Ebook owner 
    // @return true if the address has an eBook NFT 
    function iseBookNFTOwner( address _userAddress) public view returns(bool) {
        if (ownedTokens[_userAddress] > 0) {
            return true;
        } 
        return false;
    }

    //  @dev To receive ETH
    // receive() external payable {}
}
