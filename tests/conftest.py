import pytest
from devtools import debug
from eth_abi import encode
from eth_utils import encode_hex, is_checksum_address
from ethpm_types import HexBytes


def encode_cwia_runtime(logic: str, immutables: bytes):
    """
    see also
    https://github.com/wighawag/clones-with-immutable-args/blob/master/src/ClonesWithImmutableArgs.sol
    """
    extra_push = encode(['uint256'], [len(immutables) + 2])[-2:]
    extra_footer = encode(['uint256'], [len(immutables)])[-2:]
    
    debug(extra_push.hex(), extra_footer.hex())
    
    parts = [
        HexBytes("3d3d3d3d363d3d3761"),
        extra_push,
        HexBytes("603736393661"),
        extra_push,
        HexBytes("013d73"),
        HexBytes(str(logic)),
        HexBytes("5af43d3d93803e603557fd5bf3"),
        HexBytes(immutables),
        extra_footer,
    ]
    print(parts)
    return encode_hex(b"".join(parts))


def encode_immutables(*args):
    """
    encode immutables to be compatible with your methods for reading data.
    here i pack addresses as 20 bytes.
    """
    buffer = HexBytes(b'')
    offsets = []
    for arg in args:
        offsets.append(len(buffer))
        match arg:
            case str() as a if is_checksum_address(a):
                buffer += HexBytes(a)
            case int():
                buffer += arg.to_bytes(32, 'big')
            case _:
                raise ValueError(f'type {type(arg)} not supported')

    return buffer, offsets



@pytest.fixture
def template(project, accounts):
    return project.VyperCWIA.deploy(sender=accounts[0])


@pytest.fixture
def clone(template, project, chain):
    token0 = "0x0000000000000000000000000000000000000100"
    token1 = "0x0000000000000000000000000000000000000200"
    fee_tier = 300
    immutables, offsets = encode_immutables(token0, token1, fee_tier)
    debug(offsets)

    mock_address = "0x0000000000000000000000000000000000009000"
    runtime_code = encode_cwia_runtime(template, immutables)

    chain.provider.set_code(mock_address, runtime_code)

    return project.VyperCWIA.at(mock_address)