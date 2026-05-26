import hre from "hardhat";

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Voting = await hre.ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();

  await voting.waitForDeployment();

  const address = await voting.getAddress();
  console.log("Voting Contract deployed to:", address);

  console.log("Adding initial candidates...");
  let tx = await voting.addCandidate("John Doe", "Democratic Party", "Ward A");
  await tx.wait();

  tx = await voting.addCandidate("Jane Smith", "Republican Party", "Ward B");
  await tx.wait();

  tx = await voting.addCandidate("Alice Johnson", "Independent", "Ward A");
  await tx.wait();

  console.log("Initial candidates added.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
