require("@nomicfoundation/hardhat-toolbox");

const projectID = "paste project id here";
const privateKey = "paste private key here";

task("accounts", "Print the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for(const account of accounts){
    console.log(account.address);
  }
})

module.exports = {
  networks: {
    hardhat: {
      chainId: 1337
    },
     rinkeby: {
       url: `paste infura url here"`,
       accounts: [privateKey]
     }
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
