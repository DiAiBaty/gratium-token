// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Gratium is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10 ** 18;

    uint256 public constant AIRDROP_PERCENT = 30;
    uint256 public constant REWARDS_AUTO_PERCENT = 25;
    uint256 public constant REWARDS_DAO_PERCENT = 10;
    uint256 public constant TEAM_NOW_PERCENT = 10;
    uint256 public constant TEAM_LOCKED_PERCENT = 10;
    uint256 public constant LIQUIDITY_PERCENT = 5;
    uint256 public constant RESERVE_PERCENT = 10;

    address public immutable teamLockedWallet;
    uint256 public immutable teamLockedUntil;

    address public rewardDistributor;
    address public daoRewardController;

    mapping(address => uint256) public firstReceivedAt;
    mapping(address => uint256) public lastMaxBalance;
    mapping(address => uint256) public donatedAmount;
    mapping(address => uint256) public burnDebt;
    mapping(address => bool) public isAirdropAddress;

    uint256 public constant DONATION_REQUIREMENT_PERCENT = 10;
    uint256 public constant INACTIVITY_BURN_PERCENT = 25;
    uint256 public constant GRACE_PERIOD = 10 days;

    event Burned(address indexed user, uint256 amount);
    event Donated(address indexed user, uint256 amount);

    constructor(
        address _teamLockedWallet,
        address _rewardDistributor,
        address _daoRewardController
    ) ERC20("Gratium", "GRA") {
        require(_teamLockedWallet != address(0), "Invalid locked wallet");
        require(_rewardDistributor != address(0), "Invalid distributor");
        require(_daoRewardController != address(0), "Invalid DAO");

        teamLockedWallet = _teamLockedWallet;
        teamLockedUntil = block.timestamp + 270 days;
        rewardDistributor = _rewardDistributor;
        daoRewardController = _daoRewardController;

        _mint(msg.sender, MAX_SUPPLY * AIRDROP_PERCENT / 100);
        _mint(_rewardDistributor, MAX_SUPPLY * REWARDS_AUTO_PERCENT / 100);
        _mint(_daoRewardController, MAX_SUPPLY * REWARDS_DAO_PERCENT / 100);
        _mint(msg.sender, MAX_SUPPLY * TEAM_NOW_PERCENT / 100);
        _mint(_teamLockedWallet, MAX_SUPPLY * TEAM_LOCKED_PERCENT / 100);
        _mint(msg.sender, MAX_SUPPLY * LIQUIDITY_PERCENT / 100);
        _mint(msg.sender, MAX_SUPPLY * RESERVE_PERCENT / 100);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (firstReceivedAt[recipient] == 0) {
            firstReceivedAt[recipient] = block.timestamp;
        }
        _updateBalanceSnapshot(recipient);
        _updateBalanceSnapshot(msg.sender);
        return super.transfer(recipient, amount);
    }

    function _updateBalanceSnapshot(address user) internal {
        uint256 balance = balanceOf(user);
        if (balance > lastMaxBalance[user]) {
            lastMaxBalance[user] = balance;
        }
    }

    function donate(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        donatedAmount[msg.sender] += amount;
        _burn(msg.sender, amount);
        emit Donated(msg.sender, amount);
    }

    function calculateDebt(address user) public view returns (uint256) {
        uint256 maxBalance = lastMaxBalance[user];
        uint256 required = maxBalance * DONATION_REQUIREMENT_PERCENT / 100;
        uint256 donated = donatedAmount[user];
        if (required <= donated) return 0;
        return required - donated;
    }

    function burnInactive(address[] calldata users) external onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            address user = users[i];
            if (
                block.timestamp < firstReceivedAt[user] + GRACE_PERIOD
            ) {
                continue;
            }
            uint256 debt = calculateDebt(user);
            if (debt == 0) continue;

            uint256 burnAmount = debt * INACTIVITY_BURN_PERCENT / DONATION_REQUIREMENT_PERCENT;
            if (balanceOf(user) >= burnAmount) {
                _burn(user, burnAmount);
                emit Burned(user, burnAmount);
            }
        }
    }

    function markAirdropAddress(address user) external onlyOwner {
        isAirdropAddress[user] = true;
    }

    function batchDistribute(address[] calldata recipients, uint256[] calldata amounts) external {
        require(msg.sender == rewardDistributor, "Not authorized");
        require(recipients.length == amounts.length, "Length mismatch");
        for (uint i = 0; i < recipients.length; i++) {
            _transfer(msg.sender, recipients[i], amounts[i]);
        }
    }

    function updateRewardDistributor(address newDistributor) external onlyOwner {
        rewardDistributor = newDistributor;
    }

    function updateDAORewardController(address newController) external onlyOwner {
        daoRewardController = newController;
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }
}
