//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
 
import "./eBookNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
 
/** 
  * @notice Give the ability to deploy a contract to manage our ERC-721 eBook 
  * @dev    If the contract is already deployed for an Author, it will revert.
  */
contract eBookFactory is Ownable {
 
    // keep all coolection address for an Author
    mapping(address => address[]) public eBookCollections;

    event evtBookCollectionCreated(string _TitleName, address _collectionAddress, uint _timestamp);
    event evtFundReceived(address _address, uint _amount);

    // @notice Deploy the ERC-721 Collection contract of the Author caller 
    // @return collectionAddress the address of the created collection contract
    function factoryCreateNFTCollection(string memory _TitleName) internal returns (address) {
        address collectionAddress;
        // Import the bytecode of the contract to deploy
        bytes memory collectionBytecode = type(eBookNFT).creationCode;
		
        // Make a random salt based on the artist name
        bytes32 salt = keccak256(abi.encodePacked(_TitleName));
 
        assembly {
            collectionAddress := create2(0, add(collectionBytecode, 0x20), mload(collectionBytecode), salt)
            if iszero(extcodesize(collectionAddress)) {
                // revert if something gone wrong (collectionAddress doesn't contain an address)
                revert(0, 0)
            }
        }

        // Save the contracts address for this Author 
        eBookCollections[msg.sender].push(collectionAddress);

        emit evtBookCollectionCreated(_TitleName, collectionAddress, block.timestamp);

        return collectionAddress;
    }

    // @notice Get a table with all eBooks collections of the same Author
    // @param addr address of an Author
    // @return collectionAddress the address of the created collection contract
    function getAuthorCollections(address addr) public view returns (address[] memory) {
        return eBookCollections[addr];
    }
}