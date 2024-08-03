// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "../lib/forge-std/src/Test.sol";
import "../src/UniswapV3.sol";
import '../src/utils/DaiToken.sol';
import '../src/utils/WethToken.sol';

contract UniswapV3LiquidityTest is Test {
    DaiToken private dai;
    WethToken private weth;

    UniswapV3Liquidity private uni;

    address private constant DAI_WHALE = 0xe81D6f03028107A20DBc83176DA82aE8099E9C42;

    function setUp() public {
        // Initialize TestDai and TestWeth contracts
        dai = new DaiToken();
        weth = new WethToken();

        dai.deposit{value:20 * 1e18}();
           
        dai.transfer(address(this), 20 * 1e18);

        weth.deposit{value: 2 * 1e18}(); // Assuming TestWeth has a deposit function

        // Approve tokens for UniswapV3Liquidity
        dai.approve(address(uni), 20 * 1e18);   
        weth.approve(address(uni), 2 * 1e18);
    }

    function testLiquidity() public {
        // Track total liquidity
        uint128 liquidity;

        // Mint new position
        uint256 daiAmount = 10 * 1e18;
        uint256 wethAmount = 1e18;

        (
            uint256 tokenId,
            uint128 liquidityDelta,
            uint256 amount0,
            uint256 amount1
        ) = uni.mintNewPosition(daiAmount, wethAmount);
        liquidity += liquidityDelta;

        console2.log("--- Mint new position ---");
        console2.log("token id", tokenId);
        console2.log("liquidity", liquidity);
        console2.log("amount 0", amount0);
        console2.log("amount 1", amount1);

        // Collect fees
        (uint256 fee0, uint256 fee1) = uni.collectAllFees(tokenId);

        console2.log("--- Collect fees ---");
        console2.log("fee 0", fee0);
        console2.log("fee 1", fee1);

        // Increase liquidity
        uint256 daiAmountToAdd = 5 * 1e18;
        uint256 wethAmountToAdd = 0.5 * 1e18;

        (liquidityDelta, amount0, amount1) = uni.increaseLiquidityCurrentRange(
            tokenId, daiAmountToAdd, wethAmountToAdd
        );
        liquidity += liquidityDelta;

        console2.log("--- Increase liquidity ---");
        console2.log("liquidity", liquidity);
        console2.log("amount 0", amount0);
        console2.log("amount 1", amount1);

        // Decrease liquidity
        (amount0, amount1) =
            uni.decreaseLiquidityCurrentRange(tokenId, liquidity);
        console2.log("--- Decrease liquidity ---");
        console2.log("amount 0", amount0);
        console2.log("amount 1", amount1);
    }
}
