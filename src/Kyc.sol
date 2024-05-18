//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

contract Kyc {
    address public admin;

    struct Customer {
        string userName;
        string data;
        address bank;
        uint upVotes;
        uint downVotes;
        bool kycChecked;
    }

    struct Bank {
        string name;
        address ethAddress;
        uint256 regNumber;
        uint complaintsReported;
    }

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function.");
        _;
    }

    modifier onlyBank() {
        require(
            banks[msg.sender].ethAddress != address(0),
            "Only banks can call this function."
        );
        _;
    }
    mapping(string => Customer) customers;

    mapping(address => Bank) banks;

    function addCustomer(
        string memory _userName,
        string memory _customerData
    ) public onlyBank {
        require(
            customers[_userName].bank == address(0),
            "Customer is already present, please call modifyCustomer to edit the customer data"
        );
        customers[_userName].userName = _userName;
        customers[_userName].data = _customerData;
        customers[_userName].bank = msg.sender;
    }

    function viewCustomer(
        string memory _userName
    ) public view returns (string memory, string memory, address) {
        require(
            customers[_userName].bank != address(0),
            "Customer is not present in the database"
        );
        return (
            customers[_userName].userName,
            customers[_userName].data,
            customers[_userName].bank
        );
    }

    function modifyCustomer(
        string memory _userName,
        string memory _newcustomerData
    ) public onlyBank {
        require(
            customers[_userName].bank != address(0),
            "Customer is not present in the database"
        );
        customers[_userName].data = _newcustomerData;
    }

    function addBank(
        string memory _name,
        address _address,
        uint256 _regNumber
    ) public onlyAdmin {
        require(
            banks[_address].ethAddress == address(0),
            "bank already exists"
        );
        banks[_address].name = _name;
        banks[_address].ethAddress = _address;
        banks[_address].regNumber = _regNumber;
    }

    function removeBank(address _address) public onlyAdmin {
        delete banks[_address];
    }

    function reportComplaint(address _address) public onlyBank {
        banks[_address].complaintsReported += 1;
    }

    function upVote(string memory _userName) public onlyBank {
        customers[_userName].upVotes += 1;
    }

    function downVote(string memory _userName) public onlyBank {
        customers[_userName].downVotes += 1;
    }

    function kycStatus(string memory _userName) public view returns (bool) {
        if (customers[_userName].upVotes >= customers[_userName].downVotes) {
            return true;
        } else return false;
    }

    function updateKycStatus(string memory _userName) public onlyBank {
        if (customers[_userName].upVotes >= customers[_userName].downVotes) {
            customers[_userName].kycChecked = true;
        } else {
            customers[_userName].kycChecked = false;
        }
    }

    function getBankName(address _address) public view returns (string memory) {
        string memory name = banks[_address].name;
        return name;
    }

    function getBankReg(address _address) public view returns (uint256) {
        uint256 regNum = banks[_address].regNumber;
        return regNum;
    }

    function getCustData(
        string memory _name
    ) public view returns (string memory) {
        string memory data = customers[_name].data;
        return data;
    }
}
