// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Election {
    address public ElectionCommission;

    struct Party {
        string name;
        uint totalVote;
    }

    struct Voter {
        bool isRegistered;
        bool hasVote;
        uint age;
    }

    Party[] public politicalParties;
    mapping(address => Voter) public voters;

    modifier onlyElectionCommission() {
        require(
            msg.sender == ElectionCommission,
            "You are not from Election Commission"
        );
        _;
    }

    constructor() {
        ElectionCommission = msg.sender;
    }

    function registerPoliticalParty(
        string memory _name
    ) public onlyElectionCommission {
        for (uint i = 0; i < politicalParties.length; i++) {
            require(
                keccak256(bytes(politicalParties[i].name)) !=
                    keccak256(bytes(_name)),
                "Party name already exists"
            );
        }

        politicalParties.push(Party(_name, 0));
    }

    function registerVoter(
        address _voter,
        uint _age
    ) public onlyElectionCommission {
        require(
            !voters[_voter].isRegistered,
            "Voter already registered"
        );
        require(_age >= 18, "Voter is underaged");

        voters[_voter] = Voter({
            isRegistered: true,
            hasVote: false,
            age: _age
        });
    }

    function voting(uint _index) public {
        require(
            voters[msg.sender].isRegistered,
            "Voter is not registered"
        );
        require(
            !voters[msg.sender].hasVote,
            "Voter has already voted"
        );
        require(
            _index < politicalParties.length,
            "Invalid party index"
        );

        politicalParties[_index].totalVote += 1;
        voters[msg.sender].hasVote = true;
    }

    function watchResult() public view returns (string memory) {
        uint winnerIndex = 0;

        for (uint i = 1; i < politicalParties.length; i++) {
            if (
                politicalParties[i].totalVote >
                politicalParties[winnerIndex].totalVote
            ) {
                winnerIndex = i;
            }
        }

        return politicalParties[winnerIndex].name;
    }
}
