# @version 0.3.10

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
