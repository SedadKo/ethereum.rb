require 'spec_helper'

describe Ethereum do

  before(:all) do
    @contract_path = "#{Dir.pwd}/spec/fixtures/greeter.sol"
  end

  it "compiles contract to bin" do
    contract = Ethereum::Solidity.new.compile(@contract_path)
    code = '60606040526040516102563803806102568339810160405280510160008054600160a060020a031916331790558060016000509080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1060a057805160ff19168380011785555b50608f9291505b8082111560cd5760008155600101607d565b505050610185806100d16000396000f35b828001600101855582156076579182015b82811115607657825182600050559160200191906001019060b1565b509056606060405260e060020a600035046341c0e1b58114610029578063cfae321714610070575b610002565b34610002576100de6000543373ffffffffffffffffffffffffffffffffffffffff9081169116141561014e5760005473ffffffffffffffffffffffffffffffffffffffff16ff5b3461000257604080516020818101835260008252600180548451600282841615610100026000190190921691909104601f81018490048402820184019095528481526100e094909283018282801561017b5780601f106101505761010080835404028352916020019161017b565b005b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600302600f01f150905090810190601f1680156101405780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b565b820191906000526020600020905b81548152906001019060200180831161015e57829003601f168201915b505050505090509056'
    expect(code).to eq contract[:bin]
  end

  it "compiles contract to abi" do
    contract = Ethereum::Solidity.new(@tmp_path).compile(@contract_path)
    expected_abi = '[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"type":"constructor"}]'
    expect(expected_abi).to eq contract[:abi].strip
  end

  it "raises SystemCallError if can't run solc" do
    expect { Ethereum::Solidity.new(@tmp_path, 'no_solc').compile(@contract_path) }.to raise_error(SystemCallError)
  end

  it "builds proper path" do
    compiler = Ethereum::Solidity.new("/tmp")
    expect(compiler.path_for("/contracts/super.sol", "abi").to_path).to eq "/tmp/super.abi"
  end
  
end
