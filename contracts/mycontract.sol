// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
    // DO NOT MODIFY ABOVE THIS

    // ADD YOUR CONTRACT CODE BELOW

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    address[] public participantList;
    mapping(address => bool) public isParticipate;

    struct Creditor {
        address credAddr;
        uint32 amount;
    }

    mapping(address => Creditor[]) public debtors;

    function addParticipant(address _participant) private {
        if (!isParticipate[_participant]) {
            participantList.push(_participant);
            isParticipate[_participant] = true;
        }
    }

    function getAllParticipant() public view returns (address[] memory) {
        return participantList;
    }

    function getOwedData(address user)
        public
        view
        returns (Creditor[] memory)
    {
        return debtors[user];
    }

    function getTotalOwedAmount(address user) public view returns (uint32) {
        uint32 totalOwedAmount = 0;

        // Iterate over the creditor for the given debtor
        for (uint256 i = 0; i < debtors[user].length; i++) {
            totalOwedAmount += debtors[user][i].amount;
        }
        return totalOwedAmount;
    }

    function lookup(address _debtor, address _creditor)
        public
        view
        returns (uint32)
    {
        // Iterate over the debtor to find the given creditor
        for (uint256 i = 0; i < debtors[_debtor].length; i++) {
            if (debtors[_debtor][i].credAddr == _creditor) {
                return debtors[_debtor][i].amount;
            }
        }
        return 0;
    }

    function add_IOU(address _creditorAddr, uint32 _amount) public {
        address _debtorAddr = msg.sender;
        require(_debtorAddr != _creditorAddr, "You cannot owe yourself!");
        addParticipant(_debtorAddr);
        addParticipant(_creditorAddr);

        // Find a creditor that owes me (เขายืมเรา)
        for (uint256 i = 0; i < debtors[_creditorAddr].length; i++) {
            Creditor memory creditor = debtors[_creditorAddr][i];

            // Find if this creditor owe with this debtor? to update an owning amount
            if (creditor.credAddr == _debtorAddr) {
                if (creditor.amount >= _amount) {
                    // เขายืมเรา มากกว่า เราจะยืมเขา
                    creditor.amount -= _amount;
                    return;
                } else {
                    // Still has owe remain

                    _amount -= creditor.amount;
                    delete debtors[_creditorAddr][i];

                    // Find a creditor that I owes (เราเคยยืมเขา +เพิ่ม)
                    for (uint256 j = 0; j < debtors[_debtorAddr].length; j++) {
                        Creditor memory debtor = debtors[_debtorAddr][j];

                        // Find if this debtor owe with this creditor? to update an owning amount
                        if (debtor.credAddr == _creditorAddr) {
                            debtor.amount += _amount;
                            return;
                        }
                    }

                    // Never borrow this creditor
                    Creditor memory newDebt = Creditor(_creditorAddr, _amount);
                    debtors[_debtorAddr].push(newDebt);
                    return;
                }
            }
        }
    }

    // UTILs function
    function getYourAddress() public view returns (address) {
        return msg.sender;
    }
}
