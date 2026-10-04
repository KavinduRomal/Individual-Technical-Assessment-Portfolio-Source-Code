// SPDX-License-Identifier: GPL-3.0
// COMP842 Individual Technical Assessment Portfolio - Exercise 6
// Student: [YOUR NAME] ([YOUR STUDENT ID])
// Based on the Storage contract in Remix's default workspace (contracts/1_Storage.sol)

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title StudentStorage
 * @dev The tutorial Storage contract, extended with one additional variable,
 *      studentId, for a simple student-record application. The function that
 *      updates studentId is restricted to the contract owner.
 *      Note: data stored on a public blockchain is permanent and visible to
 *      everyone, so only a sample ID should be stored, never a real one.
 */
contract StudentStorage {

    // ---------------- State variables ----------------

    uint256 number;               // original variable from 1_Storage.sol
    string private studentId;     // NEW: the additional variable
    address public owner;         // the account that deployed the contract

    // ---------------- Events ----------------

    event NumberStored(address indexed by, uint256 value);
    event StudentIdUpdated(address indexed by, string oldValue, string newValue);

    // ---------------- Constructor ----------------

    constructor() {
        owner = msg.sender;       // the deploying account becomes the owner
        studentId = "UNSET";
    }

    // ---------------- Access control ----------------

    /**
     * @dev Stops the transaction unless the caller is the owner.
     *      The underscore marks where the body of the protected function runs.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Access denied: caller is not the contract owner");
        _;
    }

    // ---------------- Original Storage functions ----------------

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
        emit NumberStored(msg.sender, num);
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256) {
        return number;
    }

    // ---------------- New variable, protected by access control ----------------

    /**
     * @dev Update the student ID. Only the owner can call this.
     * @param newStudentId the new value to store
     */
    function setStudentId(string memory newStudentId) public onlyOwner {
        require(bytes(newStudentId).length > 0, "Student ID cannot be empty");
        string memory oldValue = studentId;
        studentId = newStudentId;
        emit StudentIdUpdated(msg.sender, oldValue, newStudentId);
    }

    /**
     * @dev Return the stored student ID. A view function reads state without
     *      changing it, so calling it does not create a transaction.
     */
    function getStudentId() public view returns (string memory) {
        return studentId;
    }
}
