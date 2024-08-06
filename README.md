**get start**

first,you need to install foundry for test
```shell
curl -L https://foundry.paradigm.xyz | bash
rustup update stable
cargo install --git https://github.com/foundry-rs/foundry --profile release --locked forge cast chisel anvil
```

run uniswapV3 test
```shell
forge script test/UniswapV3LiquidityTest.sol --fork-url https://eth-mainnet.g.alchemy.com/v2/etKZmqnvvzqpjUnO1lU5YJ0LZoC3lRhs --broadcast
forge script test/UniswapV3SwapTest.sol --fork-url https://eth-mainnet.g.alchemy.com/v2/etKZmqnvvzqpjUnO1lU5YJ0LZoC3lRhs --broadcast
```

run other test
```shell
forge test --match-path test/InvestPlatformTest.sol
```

## project discribe

**Erc20**

cryptocurrency which follow erc20 protocol support tha function above: deposit, withdraw, totalSupply, approve, transfer, transferFrom. you will see the usage of this function in testing.

**invest platform**

This project simulates an investment platform. The consultant gives an investment target. If the profit does not meet expectations, he will pay a deposit for return (I set it at 10% of the investment). The profit that exceeds his promised target is the consultant's reward. One step closer There needs to be a stock investment institution as a commander.


## Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
