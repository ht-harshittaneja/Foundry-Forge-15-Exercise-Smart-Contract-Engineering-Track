# Foundry Forge: 15-Exercise Smart Contract Engineering Track

A collection of 15 small, self-contained [Foundry](https://book.getfoundry.sh/) projects for learning Solidity smart contract development. Each exercise focuses on one part of the Foundry workflow (testing, fuzzing, gas reports, scripting, forking, CI, and so on), and the last one combines everything into a small crowdfunding contract.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Exercises](#exercises)
- [Project Structure](#project-structure)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Example / Output](#example--output)
- [Learning Outcomes](#learning-outcomes)

## Overview

The repository is a hands-on practice track. Every folder (`Q01` to `Q15`) is an independent Foundry project with its own contract, tests, deployment script and short README that states the problem and the concepts covered.

The exercises start with project setup and a simple counter, move through testing, fuzzing, gas optimization, deployment and mainnet forking, and finish with a capstone that uses the full workflow.

All contracts are written for learning. They are simplified and have not been audited, so they should not be used with real funds.

## Features

- 15 exercises, each a standalone Foundry project that can be built and tested on its own.
- Solidity contracts covering common patterns: counter, bank, token swap, auction, voting, NFT, multisig wallet, vault, subscription and crowdfunding.
- Unit tests, fuzz tests and an invariant test written with `forge-std`.
- Use of Foundry cheatcodes such as `vm.prank`, `vm.warp`, `vm.deal`, `vm.expectRevert`, `vm.expectEmit` and `vm.createSelectFork`.
- Gas comparison between two implementations (Q05) and a saved gas report for the capstone (Q15).
- Deployment scripts (`forge script`) in every exercise that has contracts.
- Multiple compiler profiles in `foundry.toml` (Q12).
- A GitHub Actions workflow for formatting, build and test checks.

## Technologies Used

- **Solidity** 
- **Foundry**: `forge` (build, test, script, snapshot, gas report), `cast`, `anvil` and `chisel`
- **forge-std**: test and script helpers (included under each exercise's `lib/` folder)
- **OpenZeppelin Contracts**: used for the ERC-20 token in Q07
- **Aave** (via a mainnet fork): used in Q10
- **GitHub Actions**: CI workflow using `foundry-rs/foundry-toolchain`

## Exercises

| Exercise | Contract(s) | What it covers |
|---|---|---|
| Q01 Foundry Setup & First Contract | `Counter` | Project setup, `forge build`, `forge test`, a basic fuzz test |
| Q02 Tools of the Trade – Cast, Anvil, Chisel | `Greeting` | A readable and updatable string, used with Cast, Anvil and Chisel |
| Q03 Testing Basics in Solidity | `Bank` | Deposit and withdraw, `assertEq`, `expectRevert` |
| Q04 Fuzzing and Property Testing | `ERC20`, `TokenSwap` | Fuzz tests with `bound` and `vm.assume`, an invariant test on pool balance |
| Q05 Gas Reports & Optimization | `GasOptimizationV1`, `GasOptimizationV2` | Paying users one by one vs. in a batch; gas snapshots with and without the optimizer |
| Q06 Time Travel & Events in Test | `Auction` | `vm.warp` for time-based logic, `vm.expectEmit` for events |
| Q07 Managing Dependencies | `MyToken` | OpenZeppelin ERC-20 imported from `lib/` |
| Q08 Solidity Deployment Scripts | `Voting` | Adding proposals and voting; deployment with `forge script` |
| Q09 Real Chain Interactions Using Cast | `SimpleNFT` | Minimal NFT (mint, transfer, approve, burn) meant to be driven with `cast send` / `cast call` |
| Q10 Testing with Mainnet Forks | `MainnetFork` | Supplying WETH and borrowing USDC on Aave using a forked mainnet |
| Q11 CI CD with GitHub Actions | none (workflow only) | Format check, build and test on every push and pull request |
| Q12 Foundry Configs and Compiler Settings | `Multisig` | 2-of-3 multisig; `foundry.toml` profiles with different optimizer settings |
| Q13 Security & Testing Cheatcodes | `Vault` | ETH vault with owner-only pause and a reentrancy guard |
| Q14 AI-Powered Development | `Subscription` | A 30-day subscription contract, generated with AI and then tested |
| Q15 Capstone Project – Foundry in Action | `Crowdfunding` | Campaigns with a goal and deadline, contributions, withdrawal and refunds; full tests and gas report |

## Project Structure

```text
.
├── .github/workflows/test.yml    # CI workflow (format check, build, test)
├── README.md
├── Q01 .../ to Q15 ...           # one Foundry project per exercise
```

Each exercise folder follows the standard Foundry layout:

```text
QXX <Exercise Name>/
├── src/            # contract(s)
├── test/           # Forge tests (*.t.sol)
├── script/         # deployment script (*.s.sol)
├── lib/            # dependencies (forge-std; also OpenZeppelin in Q07)
├── foundry.toml    # Foundry configuration
├── foundry.lock    # pinned dependency versions
└── README.md       # problem statement and concepts for that exercise
```

Extra files in specific exercises:

- `Q05`: `.gas-snapshot`, `no-optimizer.snap` and `optimizer-200.snap` (saved gas snapshots).
- `Q11`: contains only a README and a reference copy of the CI workflow.
- `Q12`: `foundry.toml` defines the `default`, `optimized` and `no_optimizer` profiles.
- `Q15`: `reports/gas-report.txt` (saved output of a gas report).

## Installation and Setup

**Prerequisites:** Git and Foundry. If Foundry is not installed, follow the [official installation guide](https://book.getfoundry.sh/getting-started/installation), which at the time of writing is:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Then clone the repository:

```bash
git clone <repository-url>
cd Foundry-Forge-15-Exercise-Smart-Contract-Engineering-Track
```

Each exercise is its own project, so there is no single install step for the whole repository. Move into the exercise you want to run. Folder names contain spaces, so either quote the name or use a wildcard that matches the exercise number:

```bash
cd Q03*
```

The dependencies are already included in each exercise's `lib/` folder. If a `lib/` folder is empty on your machine, `forge install` can fetch them again (for example `forge install foundry-rs/forge-std`).

## Usage

Run these commands from inside an exercise folder.

Build the contracts:

```bash
forge build
```

Run the tests with verbose output:

```bash
forge test -vvv
```

Run a single test by name:

```bash
forge test --match-test test_Deposit
```

Check formatting (the same check used by the CI workflow):

```bash
forge fmt --check
```

### Exercise-specific notes

- **Q05 (gas):** `forge snapshot` writes a `.gas-snapshot` file, and `forge test --gas-report` prints a per-function gas table.
- **Q10 (mainnet fork):** the test reads the `MAINNET_RPC_URL` environment variable, so you need an Ethereum mainnet RPC endpoint (for example from a provider such as Alchemy or Infura). Without it, the test fails in `setUp`.

  ```bash
  export MAINNET_RPC_URL=<your-mainnet-rpc-url>
  forge test -vvv
  ```

- **Q12 (profiles):** to build or test with a different profile defined in `foundry.toml`:

  ```bash
  FOUNDRY_PROFILE=optimized forge test
  FOUNDRY_PROFILE=no_optimizer forge test
  ```

  The deployment script for this exercise reads three addresses from the environment (`ALICE`, `BOB`, `CHARLIE`).

- **Deployment scripts (all exercises with contracts):** start a local chain in one terminal and deploy from another. Replace the placeholder with one of the test private keys that Anvil prints on startup.

  ```bash
  anvil
  ```

  ```bash
  forge script script/Counter.s.sol --rpc-url http://127.0.0.1:8545 --private-key <PRIVATE_KEY> --broadcast
  ```

  The script file name differs per exercise (for example `script/Bank.s.sol` in Q03).

- **Q09 (Cast):** after deploying `SimpleNFT` to a local Anvil chain, the contract can be used from the terminal, for example:

  ```bash
  cast send <NFT_ADDRESS> "mint(uint256,string)" 1 "ipfs://metadata/1" --rpc-url http://127.0.0.1:8545 --private-key <PRIVATE_KEY>
  cast call <NFT_ADDRESS> "ownerOf(uint256)(address)" 1 --rpc-url http://127.0.0.1:8545
  ```

## Example / Output

The Q15 capstone includes a saved gas report (`reports/gas-report.txt`). An excerpt of its contents:

```text
Ran 7 tests for test/Crowdfunding.t.sol:CrowdfundingTest
[PASS] testCannotContributeAfterDeadline() (gas: 158763)
[PASS] testCannotWithdrawBeforeDeadline() (gas: 234461)
[PASS] testCannotWithdrawIfGoalNotReached() (gas: 239386)
[PASS] testContribution() (gas: 209038)
[PASS] testCreateCampaign() (gas: 136935)
[PASS] testRefundAfterFailedCampaign() (gas: 240587)
[PASS] testSuccessfulWithdrawal() (gas: 268506)
Suite result: ok. 7 passed; 0 failed; 0 skipped
```

The Q05 snapshot files record the result of the gas comparison. With the optimizer enabled (200 runs), paying three users one by one costs 181,645 gas, while one batch call costs 140,453 gas.

## Learning Outcomes

The exercises demonstrate:

- Setting up, building and testing a Foundry project.
- Writing unit, fuzz and invariant tests, and covering failure cases with `expectRevert`.
- Using cheatcodes to simulate users, balances, time and emitted events.
- Reading gas reports and snapshots, and comparing optimizer settings.
- Managing dependencies with `forge install` and importing OpenZeppelin contracts.
- Writing deployment scripts and interacting with contracts using Anvil and Cast.
- Testing against real protocol state with a mainnet fork.
- Common contract patterns: access control, pausing, a reentrancy guard, checks-effects-interactions ordering, time-based logic and refunds.
- Configuring `foundry.toml` profiles and setting up basic CI with GitHub Actions.