// SPDX-License-Identifier: UNLICENCED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SafeBank is ReentrancyGuard {
    mapping(address => uint256) private balances;
    uint256 private totalBalance;
 
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    // attacker may call withdraw function as much as he wants in the same transaction. 
    function withdraw() external nonReentrant {
        uint256 amount = balances[msg.sender];
        (bool sent, ) = payable(msg.sender).call{ value: amount }("");
        require(sent, "failed to sent");
        // the following code has not been executed yet. in the mean while the attack.sol receive() function would be executed again and again after sending ether.
        balances[msg.sender] = 0;
        totalBalance -= amount;
    }

    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }

    function getTotalBalance() external view returns (uint256) {
        return totalBalance;
    }
}