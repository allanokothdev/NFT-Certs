//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//Security Package to avoid continuous request of buying and selling
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTTransfer is ReentrancyGuard {
    using Counters for Counters.Counter;

    // auto-increment field for
    //  Item Id and No. of Items Transferred
    Counters.Counter private _itemIds;
    Counters.Counter private _itemTrans;

    address publisher;

    constructor() {
        publisher = msg.sender;
    }

    // Data Structure of a certificate
    struct Certificate {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address student;
        address publisher;
        bool transferred;
    }

    // Mapping the Certificates with respect to their IDs.
    mapping(uint256 => Certificate) private certificateIds;

    event CertificateItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address student,
        address publisher,
        bool transferred
    );

    /// @notice Function for Creating a certificate on the Platform
    /// @param nftContract: NFT contract address
    /// @param tokenId: Token Id of the contract.
    function createCertificate(address nftContract, uint256 tokenId)
        public
        payable
        nonReentrant
    {
        require(msg.sender == publisher,"Only the admin can publish certificates");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        certificateIds[itemId] = Certificate(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            publisher,
            false
        );

        // Transferring the NFT contract from the User to the Address of this contact
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        // Triggering the CertificateItemCreated event
        emit CertificateItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            publisher,
            false
        );
    }

    /// @notice Function to transfer certificate from the Contract Address to the applicant address.
    /// @param nftContract: NFT contract address
    /// @param itemId: Item Id in the certificateIds map.
    /// @param applicantAdd: Address of the applicant where to transfer the certificate
    function transferCertificate(
        address nftContract,
        uint256 itemId,
        address applicantAdd
    ) public payable nonReentrant {
        uint256 tokenId = certificateIds[itemId].tokenId;

        IERC721(nftContract).transferFrom(address(this), applicantAdd, tokenId);

        certificateIds[itemId].publisher = payable(applicantAdd);

        certificateIds[itemId].transferred = true;
        _itemTrans.increment();
    }

    /// @notice Returns the Certificates created
    function fetchCertificatesCreated()
        public
        view
        returns (Certificate[] memory)
    {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (certificateIds[i + 1].publisher == msg.sender) {
                itemCount += 1;
            }
        }

        Certificate[] memory items = new Certificate[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (certificateIds[i + 1].publisher == msg.sender) {
                uint256 currentId = certificateIds[i + 1].itemId;
                Certificate storage currentItem = certificateIds[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }


    /// @notice Returns certificates of the user
    function fetchStudentCertificates() public view returns (Certificate[] memory) {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (certificateIds[i + 1].student == msg.sender) {
                itemCount += 1;
            }
        }

        Certificate[] memory items = new Certificate[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (certificateIds[i + 1].student == msg.sender) {
                uint256 currentId = certificateIds[i + 1].itemId;
                Certificate storage currentItem = certificateIds[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
