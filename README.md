## project discribe
This project simulates an investment platform. The consultant gives an investment target. If the profit does not meet expectations, he will pay a deposit for return (I set it at 10% of the investment). The profit that exceeds his promised target is the consultant's reward. One step closer There needs to be a stock investment institution as a commander.

**get start**

first you need to install foundry

```shell
curl -L https://foundry.paradigm.xyz | bash
```

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
