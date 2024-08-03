# mainnet-fork [![Hardhat][hardhat-badge]][hardhat] [![License: MIT][license-badge]][license]

[hardhat]: https://hardhat.org/
[hardhat-badge]: https://img.shields.io/badge/Built%20with-Hardhat-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

A Hardhat template for testing against a live network.

## Getting Started

Click the [`Use this template`](https://github.com/Patronum-Labs/mainnet-fork/generate) button at the top of the page to
create a new repository with this repo as the initial state.

### Sensible Defaults

This template comes with sensible default configurations in the following files:

```text
├── .gitignore
├── .prettierignore
├── .prettierrc.yml
├── .solhint.json
└── hardhat.config.ts
```

## Usage

### Pre Requisites

First, you need to install the dependencies:

```sh
npm install
```

### Compile

Compile the smart contracts with Hardhat:

```sh
npx hardhat compile
```

### Test

Create `.env` file and add `INFURA_KEY` to it. Run the tests with Hardhat:

```sh
npx hardhat test
```

## Forking Live Network

### Configuration

In your `hardhat.config.ts`, you'll need to configure the forked network RPC and specify the starting block number. This setup ensures that your tests run in the context of the forked state of the network:

```js
networks: {
  hardhat: {
    forking: {
      url: `https://mainnet.infura.io/v3/${INFURA_KEY}`,  // Replace with your Infura Project ID
      blockNumber: 15975554,  // Specify the block number to start the fork from
    },
  },
},
```

### Running Tests with Forked Network

Within your test scripts, you can impersonate any account from the live network and execute transactions on behalf of that account. This is particularly useful for testing interactions with existing contracts or specific scenarios on the mainnet.

**Example:**

```js
// Impersonate an existing mainnet address
const lockboxContractDeployer = await ethers.getImpersonatedSigner(
  ETH_HOLDER_WITHOUT_LYXE,
);

// Interact with a contract deployed on the mainnet
const LYXeContract = await ethers.getContractAt(
  "ReversibleICOToken", 
  LYXE_ADDRESS,
);

const LYXeHolderSigner = await ethers.getImpersonatedSigner(LYXeHolder);

await LYXeContract.connect(LYXeHolderSigner).send(
  lockbox.target,
  10,
  "0x",
);
```

In the above example:

* You impersonate the `ETH_HOLDER_WITHOUT_LYXE` address, allowing you to execute transactions as if you were this address.
* You load the `ReversibleICOToken` contract deployed on the mainnet using its address `LYXE_ADDRESS`.
* You impersonate a `LYXeHolder`, connect to the `LYXeContract`, and perform a transaction as if the caller is the `LYXeHolder`.


## Acknowledgments

This repository is inspired by and uses code from the following projects:

- [PaulRBerg/hardhat-template](https://github.com/PaulRBerg/hardhat-template/)

We are grateful to the authors and contributors of these projects for their valuable work and inspiration.

## License

This project is licensed under MIT.
