//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
 
// importing the ERC-721 contract to deploy for an artist
import "./eBookNFT.sol";
 
/** 
  * @notice Give the ability to deploy a contract to manage our ERC-721 eBook 
  * @dev    If the contract is already deployed for an Author, it will revert.
  */
contract eBookFactory{
 
    event eBookCollectionCreated(string _artistName, address _collectionAddress, uint _timestamp);
 
    /**
      * @notice Deploy the ERC-721 Collection contract of the Author caller 
      *
      * @return collectionAddress the address of the created collection contract
      */
    function createNFTCollection(string memory _artistName, string memory _artistSymbol) external returns (address collectionAddress) {
        // Import the bytecode of the contract to deploy
        bytes memory collectionBytecode = type(eBookNFT).creationCode;
				// Make a random salt based on the artist name
        bytes32 salt = keccak256(abi.encodePacked(_artistName));
 
        assembly {
            collectionAddress := create2(0, add(collectionBytecode, 0x20), mload(collectionBytecode), salt)
            if iszero(extcodesize(collectionAddress)) {
                // revert if something gone wrong (collectionAddress doesn't contain an address)
                revert(0, 0)
            }
        }

        emit eBookCollectionCreated(_artistName, collectionAddress, block.timestamp);
    }
}