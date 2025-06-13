// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title KipuBank
 * @dev A smart contract that allows users to deposit and withdraw ETH with security features, limits, and event tracking.
 * @author Sebastian Salazar
 */
contract KipuBank {
    /// @notice Maximum amount that can be withdrawn per transaction
    uint256 public immutable WITHDRAWAL_LIMIT;

    /// @notice Global deposit cap for the contract
    uint256 public immutable BANK_CAP;

    /// @notice Total ETH deposited in the contract
    uint256 public totalDeposited;

    /// @notice Total number of deposits made
    uint256 public depositCount;

    /// @notice Total number of withdrawals made
    uint256 public withdrawalCount;

    /// @notice Mapping of user addresses to their vault balances
    mapping(address => uint256) public userVaults;

    /// @notice Error for when deposit exceeds bank capacity
    error ExceedsBankCapacity(uint256 attempted, uint256 capacity);

    /// @notice Error for when withdrawal exceeds user balance
    error InsufficientBalance(uint256 requested, uint256 available);

    /// @notice Error for when withdrawal exceeds limit
    error ExceedsWithdrawalLimit(uint256 requested, uint256 limit);

    /// @notice Error for when zero ETH is sent
    error ZeroEthSent();

    /// @notice Emitted when a user deposits ETH
    event Deposit(address indexed user, uint256 amount);

    /// @notice Emitted when a user withdraws ETH
    event Withdrawal(address indexed user, uint256 amount);

    /// @notice Modifier to check if deposit does not exceed bank capacity
    modifier withinBankCap(uint256 amount) {
        if (totalDeposited + amount > BANK_CAP) {
            revert ExceedsBankCapacity(totalDeposited + amount, BANK_CAP);
        }
        _;
    }

    /**
     * @dev Constructor sets the withdrawal limit and bank capacity
     * @param _withdrawalLimit Maximum ETH per withdrawal
     * @param _bankCap Total ETH the contract can hold
     */
    constructor(uint256 _withdrawalLimit, uint256 _bankCap) {
        WITHDRAWAL_LIMIT = _withdrawalLimit;
        BANK_CAP = _bankCap;
    }

    /**
     * @notice Allows users to deposit ETH into their personal vault
     * @dev Checks for zero ETH and bank capacity before updating state
     */
    function deposit() external payable withinBankCap(msg.value) {
        if (msg.value == 0) {
            revert ZeroEthSent();
        }

        // Update state before external interactions
        userVaults[msg.sender] += msg.value;
        totalDeposited += msg.value;
        depositCount++;

        // Emit event
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice Allows users to withdraw ETH from their vault
     * @dev Follows checks-effects-interactions pattern for secure transfers
     * @param amount Amount of ETH to withdraw
     */
    function withdraw(uint256 amount) external {
        if (amount > userVaults[msg.sender]) {
            revert InsufficientBalance(amount, userVaults[msg.sender]);
        }
        if (amount > WITHDRAWAL_LIMIT) {
            revert ExceedsWithdrawalLimit(amount, WITHDRAWAL_LIMIT);
        }

        // Update state before transfer
        userVaults[msg.sender] -= amount;
        totalDeposited -= amount;
        withdrawalCount++;

        // Emit event
        emit Withdrawal(msg.sender, amount);

        // Secure ETH transfer
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert("Transfer failed");
        }
    }

    /**
     * @notice Returns the balance of a user's vault
     * @dev View function to check user balance
     * @param user Address of the user
     * @return uint256 Balance of the user
     */
    function getUserBalance(address user) external view returns (uint256) {
        return userVaults[user];
    }

    /**
     * @dev Internal function to validate contract state
     * @notice Used for internal checks, not exposed externally
     */
    function _validateState() private view {
        assert(totalDeposited <= BANK_CAP);
    }
}
