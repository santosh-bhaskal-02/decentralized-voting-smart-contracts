// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Voting
 * @dev Implements a decentralized voting system with candidate management and voter tracking.
 */
contract Voting {
    
    struct Candidate {
        uint256 id;
        string name;
        string party;
        string constituency;
        uint256 voteCount;
    }

    address public admin;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => Candidate) public candidates;
    uint256 public candidatesCount;
    mapping(uint256 => uint256) public databaseCandidateVotes;
    
    // Track if an EPIC (Voter Card) has already been used to prevent duplicate voting 
    // even if the user switches wallets.
    mapping(string => bool) public epicUsed;

    event VoteCast(address indexed voter, uint256 indexed candidateId, string epicNumber);
    event CandidateAdded(uint256 indexed id, string name, string party);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    /**
     * @dev Add a new candidate to the election.
     */
    function addCandidate(string memory _name, string memory _party, string memory _constituency) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(
            candidatesCount,
            _name,
            _party,
            _constituency,
            0
        );
        emit CandidateAdded(candidatesCount, _name, _party);
    }

    /**
     * @dev Cast a vote for a specific candidate.
     * @param _candidateId The ID of the candidate to vote for.
     * @param _epicNumber The voter's EPIC (Voter ID Card) number for off-chain verification.
     */
    function vote(uint256 _candidateId, string memory _epicNumber) public {
        // 1. Ensure backend candidate id is valid
        require(_candidateId > 0, "Invalid candidate ID");
        
        // 2. Ensure wallet hasn't voted (DISABLED to allow shared wallets)
        // require(!hasVoted[msg.sender], "This wallet address has already voted");
        
        // 3. Ensure EPIC number hasn't been used (Double verification)
        require(!epicUsed[_epicNumber], "This EPIC number has already been used to vote");

        // Record the vote
        // hasVoted[msg.sender] = true; // DISABLED to allow shared wallets
        epicUsed[_epicNumber] = true;
        databaseCandidateVotes[_candidateId]++;
        if (_candidateId <= candidatesCount) {
            candidates[_candidateId].voteCount++;
        }

        emit VoteCast(msg.sender, _candidateId, _epicNumber);
    }

    /**
     * @dev Get candidate details and vote count.
     */
    function getCandidate(uint256 _candidateId) public view returns (
        uint256 id,
        string memory name,
        string memory party,
        string memory constituency,
        uint256 voteCount
    ) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        Candidate memory c = candidates[_candidateId];
        return (c.id, c.name, c.party, c.constituency, c.voteCount);
    }

    /**
     * @dev Change admin address.
     */
    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }
}
