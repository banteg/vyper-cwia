

def test_clone(clone, accounts, chain):
    code = chain.provider.get_code(str(clone))
    
    extra_size = int.from_bytes(code[-2:], 'big')
    assert extra_size == 2 * 20 + 32 # address + address + uint256

    assert clone.offset() == 4
    assert clone.token0() == '0x0000000000000000000000000000000000000100'
    assert clone.token1() == '0x0000000000000000000000000000000000000200'
    assert clone.token0_with_arg('0x0000000000000000000000000000000000000200') == '0x0000000000000000000000000000000000000100'
    assert clone.fee_tier() == 300


def test_calldata(clone, accounts, chain):
    r = clone.offset.transact(sender=accounts[0])
    trace = chain.provider._make_request('trace_transaction', [r.txn_hash])
    assert trace[-1]['action']['input'] == (
        '0xd5556544'  # selector
        '0000000000000000000000000000000000000100'  # immutable 1
        '0000000000000000000000000000000000000200'  # immutable 2
        '000000000000000000000000000000000000000000000000000000000000012c'  # immutable 3
        '0048'  # extra
    )

    r = clone.token0_with_arg.transact('0x0000000000000000000000000000000000000200', sender=accounts[0])
    trace = chain.provider._make_request('trace_transaction', [r.txn_hash])
    assert trace[-1]['action']['input'] == (
        '0x37b2649f'  # selector
        '0000000000000000000000000000000000000000000000000000000000000200'  # call arg
        '00000000000000000000000000000000000001'  # immutable 1
        '0000000000000000000000000000000000000002'  # immutable 2
        '00000000000000000000000000000000000000000000000000000000000000012c'  # immutable 3
        '0048' # extra
    )