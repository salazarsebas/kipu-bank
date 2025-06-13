# KipuBank Smart Contract

## Description
KipuBank is a Solidity smart contract designed to allow users to deposit and withdraw ETH securely. It enforces a global deposit cap and a per-transaction withdrawal limit, tracks the number of deposits and withdrawals, and emits events for transparency. The contract follows best practices for security, including the checks-effects-interactions pattern, custom errors, and NatSpec documentation.

## Deploy on testnet
- Transaction hash: 0xb2091a200544b4d0ae69f4b04923e3c32d14980df70675d557d3dc9d1a24d386
- Contract address: 0x3c41c6779b4ccf48b0233d0baa1761340887ebb8
- Testnet: Sepolia.
- View on etherscaan: https://sepolia.etherscan.io/tx/0xb2091a200544b4d0ae69f4b04923e3c32d14980df70675d557d3dc9d1a24d386

### Key Features
- **Deposits**: Users can deposit ETH into personal vaults, with a global cap enforced.
- **Withdrawals**: Users can withdraw ETH up to a fixed limit per transaction.
- **Security**: Implements custom errors, modifiers, and secure ETH transfers.
- **Transparency**: Emits events for deposits and withdrawals; tracks transaction counts.
- **Readability**: Uses NatSpec comments and clean code structure.

## Deployment Instructions
1. **Prerequisites**:
   - [Remix](https://remix.ethereum.org/).
   - Set up a testnet wallet (MetaMask) with test ETH (Sepolia).

2. **Parameters**:
   - `_withdrawalLimit`: Set to `1 ETH` (1e18 wei) for max withdrawal per transaction.
   - `_bankCap`: Set to `100 ETH` (1e20 wei) for total contract capacity.

## Interacting with the Contract
1. **Deposit ETH**:
   - Call `deposit()` with ETH (e.g., `0.5 ETH` via MetaMask).
   - Ensure the total deposited does not exceed the `BANK_CAP`.

2. **Withdraw ETH**:
   - Call `withdraw(amount)` with the desired amount (in wei, up to `WITHDRAWAL_LIMIT`).

3. **Check Balance**:
   - Call `getUserBalance(address)` to view a user's vault balance.

## Repository Structure
- `/contracts/KipuBank.sol`: The main smart contract.
- `README.md`: This documentation file.

## Notes
- The contract is deployed on the Sepolia testnet at `0x3c41c6779b4ccf48b0233d0baa1761340887ebb8`.
- Source code is verified on [Sepolia Etherscan](https://sepolia.etherscan.io/).
