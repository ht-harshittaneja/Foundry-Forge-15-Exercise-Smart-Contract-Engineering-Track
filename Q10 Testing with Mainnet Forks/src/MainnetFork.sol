// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IAavePool {
    function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function borrow(address asset, uint256 amount, uint256 rateMode, uint16 referralCode, address onBehalfOf) external;
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract MainnetFork {
    IAavePool public pool = IAavePool(0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2);
    IERC20 public weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 public usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    function borrowUSDC(uint256 collateral, uint256 amount) external {
        weth.approve(address(pool), collateral);
        pool.supply(address(weth), collateral, address(this), 0);
        pool.borrow(address(usdc), amount, 2, 0, address(this));
    }
}
