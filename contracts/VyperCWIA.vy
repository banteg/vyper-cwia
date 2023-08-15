# @version 0.3.10
"""
@title Vyper CWIA Demo
@author banteg
@notice
    a vyper contract that can be instantiated using clones with immutable arguments
    https://github.com/wighawag/clones-with-immutable-args/tree/master
@dev
	must be created from a CWIA factory
@custom:immutables
    0                20               40
    [token0: address][token1: address][fee_tier: uint256]
"""

@view
@external
def offset() -> uint256:
    return self.get_immutable_args_offset()


@view
@external
def token0() -> address:
    return self.get_immutable_address(0)


@view
@external
def token1() -> address:
    return self.get_immutable_address(20)


@view
@external
def fee_tier() -> uint256:
    return self.get_immutable_uint256(40)


@view
@external
def token0_with_arg(arg: address) -> address:
    # check we compute the offsets correctly
    return self.get_immutable_address(0)


# utilities to read immutable args, copy them to your contract.

@view
@internal
def get_immutable_args_offset() -> uint256:
    """
    @notice read the offset of immutable args in calldata
    @dev
        immutable data section is forwarded as calldata
        with last 2 bytes of calldata encoding its length.
    """
    return len(msg.data) - convert(slice(msg.data, len(msg.data) - 2, 2), uint256) - 2


@view
@internal
def get_immutable_address(offset: uint256) -> address:
    """
    @notice read immutable address from calldata
    """
    start: uint256 = self.get_immutable_args_offset()
    return convert(slice(msg.data, start + offset, 20), address)



@view
@internal
def get_immutable_uint256(offset: uint256) -> uint256:
    """
    @notice read immutable uint256 from calldata
    """
    start: uint256 = self.get_immutable_args_offset()
    return convert(slice(msg.data, start + offset, 32), uint256)
