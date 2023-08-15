# vyper clones with immutable arguments

this repo shows an example of a vyper contract compatible with [CWIA](https://github.com/wighawag/clones-with-immutable-args/) proxy factory.

unlike eip-1167, these proxies can contain a block of immutable data.

this data is appended to calldata when making a `delegatecall` to the logic contract.

the logic contract then can calculate the offset using the data length appended as the last 2 bytes.

it provides a guarantee the contract won't try reading immutables from user input.

```bash
call [selector][arg1][arg2]
    delegatecall [selector][arg1][arg2][immutable1][immutable2][extra]
```

it is up to you how to encode and decode immutables, but you must be very careful to not mix up their offsets.

i provide one example in the `tests/` folder.

### faq

what about a vyper cwia factory? not yet possible.

can this be a native feature? write a [vyper improvement proposal](https://github.com/vyperlang/vyper/issues).
