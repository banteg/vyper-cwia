# @version 0.3.10
"""
@dev
	must be instantiated as clone with immutable arguments
    [token0: address][token1: address][param: uint256][extra_len: uint16]
"""

@view
@external
def token0() -> address:
    return self.get_immutable_address(0)


@view
@external
def token1() -> address:
    return self.get_immutable_address(32)


@view
@external
def param() -> uint256:
    return self.get_immutable_uint256(64)


# utilities to read immutable args

@view
@internal
def get_immutable_args_offset() -> uint256:
    """
    @notice read the offset of immutable args in calldata
    @dev
        immutable data section is forwarded as calldata, with a footer of
        extra_len that encodes len(immutable data) + len(extra_len) as uint16
    """
    extra_len: uint256 = convert(slice(msg.data, len(msg.data) - 2, 2), uint256)
    return len(msg.data) - extra_len


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
    return convert(slice(msg.data, start + offset, 20), uint256)
