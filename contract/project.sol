
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthDataStorage {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct HealthRecord {
        string patientName;
        string diagnosis;
        string prescription;
        uint256 timestamp;
    }

    mapping(address => HealthRecord[]) private records;
    mapping(address => bool) public isAuthorized;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender] == true, "Not authorized");
        _;
    }

    event RecordAdded(address patient, uint timestamp);
    event AuthorizationGranted(address user);
    event AuthorizationRevoked(address user);

    function addRecord(address _patient, string memory _name, string memory _diagnosis, string memory _prescription) public onlyAuthorized {
        HealthRecord memory newRecord = HealthRecord({
            patientName: _name,
            diagnosis: _diagnosis,
            prescription: _prescription,
            timestamp: block.timestamp
        });

        records[_patient].push(newRecord);
        emit RecordAdded(_patient, block.timestamp);
    }

    function getRecords(address _patient) public view returns (HealthRecord[] memory) {
        require(msg.sender == _patient || isAuthorized[msg.sender] || msg.sender == owner, "Access Denied");
        return records[_patient];
    }

    function grantAccess(address _user) public onlyOwner {
        isAuthorized[_user] = true;
        emit AuthorizationGranted(_user);
    }

    function revokeAccess(address _user) public onlyOwner {
        isAuthorized[_user] = false;
        emit AuthorizationRevoked(_user);
    }
}
