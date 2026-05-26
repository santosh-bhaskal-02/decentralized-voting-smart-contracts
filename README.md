# Decentralized Voting (Ethereum Smart Contracts)

This project contains Ethereum Solidity smart contracts and a Hardhat development environment that supports on-chain voting ledger storage for the Decentralized Voting System.

---

## 🚀 Features

- **Candidate Management**: Admins can securely register candidates (`addCandidate`) within specific constituencies.
- **Double-Voting Prevention**: Off-chain voter EPIC (voter card) numbers are linked on-chain (`epicUsed`) to prevent double-voting regardless of the wallet address used.
- **Auditable Ledger**: Public event emissions (`VoteCast`, `CandidateAdded`) for easy indexing and verification.

---

## 🛠️ Tech Stack & Key Libraries

- **Language**: Solidity (`^0.8.28`)
- **Development Framework**: Hardhat
- **Libraries**: `@nomicfoundation/hardhat-toolbox`
- **Clients**: Ethers.js for deploy scripts

---

## 🏃 Setup & Execution

### 1. Install Dependencies
```bash
npm install
```

### 2. Start a Local Hardhat Node
Start a simulated EVM node on your machine:
```bash
npx hardhat node
```
This runs a local blockchain on `http://127.0.0.1:8545` with the custom chainId `1337`.

### 3. Deploy Contracts
Compile and deploy the `Voting` contract to the local network:
```bash
npx hardhat run scripts/deploy.js --network localhost
```
The deploy script registers some initial candidates (`John Doe`, `Jane Smith`, `Alice Johnson`) and prints the deployed contract address. Make sure to copy this address and update it in your frontend configuration.

### 4. Run Contract Tests
*(If test files are added)*:
```bash
npx hardhat test
```
