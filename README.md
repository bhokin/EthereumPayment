# SplitWise
(This assignment is taken from “Programming Project #3” CS251: Cryptocurrencies and Blockchain Technologies, Stanford University)

## Getting Started

1. Install dependencies
```
$ npm install --save-dev hardhat
$ npm install --save-dev @nomiclabs/hardhat-ethers
```

2. Start the local ether node
```
npx hardhat node
```

3. Compile and Deploy the contract
```
$ npx hardhat run --network localhost scripts/deploy.js
```


4. Update the contract address and ABI in `web_app/script.js`
- Use the **<u>contract address</u>** that received from the deployment command 
- Use the **<u>ABI</u>** from `artifacts/contracts/mycontract.sol/Splitwise.json` in an ABI field

