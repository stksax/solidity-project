// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import "../src/UniswapV3Swap.sol";

contract UniswapV3SwapTest is Test {
    // address private constant DAI_WETH_POOL_3000 =
    //     0xC2e9F25Be6257c210d7Adf0D4Cd6E3E881ba25f8;

    IWETH private constant weth = IWETH(WETH);
    IERC20 private constant dai = IERC20(DAI);

    UniswapV3Swap private swap;

    uint256 private constant AMOUNT_IN_SUM = 50 * 1e18;
    uint256 private constant AMOUNT_IN = 1e18;
    uint256 private constant AMOUNT_OUT = 10 * 1e18;
    uint256 private constant MAX_AMOUNT_IN = 1e18;

    function setUp() public {
        swap = new UniswapV3Swap();
        weth.deposit{value: AMOUNT_IN_SUM}();
        weth.approve(address(swap), type(uint256).max);
    }

    function test_swapExactInputSingleHop() public {
        uint amountOutMin = 1000;
        uint256 daiBefore = dai.balanceOf(address(this));
        swap.swapExactInputSingleHop(AMOUNT_IN, amountOutMin);
        uint256 daiAfter = dai.balanceOf(address(this));
        uint256 getDai = daiAfter - daiBefore;
        console2.log("Dai balance increase", getDai);
    }

    function test_swapExactOutputSingleHop() public {
        uint256 token0Before = weth.balanceOf(address(this));
        uint256 token1Before = dai.balanceOf(address(this));
        swap.swapExactOutputSingleHop(AMOUNT_OUT, MAX_AMOUNT_IN);
        uint256 token0After = weth.balanceOf(address(this));
        uint256 token1After = dai.balanceOf(address(this));

        assertLt(token0After, token0Before, "WETH balance didn't decrease");
        assertGt(token1After, token1Before, "DAI balance didn't increase");
        uint token0Increase = token1After - token1Before;
        uint token1Decrease = token0Before - token0After;
        console2.log("Dai balance increase ", token0Increase);
        console2.log("WETH balance decrease", token1Decrease);
        assertEq(weth.balanceOf(address(swap)), 0, "WETH balance of swap != 0");
        assertEq(dai.balanceOf(address(swap)), 0, "DAI balance of swap != 0");
    }

    function test_swapExactInputMultiHop() public {
        uint amountOutMin = 1000;
        uint256 daiBefore = dai.balanceOf(address(this));
        swap.swapExactInputMultiHop(AMOUNT_IN, amountOutMin);
        uint256 daiAfter = dai.balanceOf(address(this));
        uint256 getDai = daiAfter - daiBefore;
        console2.log("Dai balance increase", getDai);
    }

    function test_swapExactOutputMultiHop() public {
        uint256 token0Before = weth.balanceOf(address(this));
        uint256 token1Before = dai.balanceOf(address(this));
        swap.swapExactOutputMultiHop(AMOUNT_OUT, MAX_AMOUNT_IN);
        uint256 token0After = weth.balanceOf(address(this));
        uint256 token1After = dai.balanceOf(address(this));

        assertLt(token0After, token0Before, "WETH balance didn't decrease");
        assertGt(token1After, token1Before, "DAI balance didn't increase");
        uint token0Increase = token1After - token1Before;
        uint token1Decrease = token0Before - token0After;
        console2.log("Dai balance increase ", token0Increase);
        console2.log("WETH balance decrease", token1Decrease);
        assertEq(weth.balanceOf(address(swap)), 0, "WETH balance of swap != 0");
        assertEq(dai.balanceOf(address(swap)), 0, "DAI balance of swap != 0");
    }

    function run() external{
        test_swapExactInputSingleHop();
        test_swapExactOutputSingleHop();
        test_swapExactInputMultiHop();
        test_swapExactOutputMultiHop();
    }
}
