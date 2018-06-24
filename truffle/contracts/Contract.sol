pragma solidity ^0.4.24;

library SafeMath {

  function mul(uint a, uint b) internal pure returns (uint c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }
  
  function div(uint a, uint b) internal pure returns (uint) {
    return a / b;
  }

  
  function sub(uint a, uint b) internal pure returns (uint) {
    assert(b <= a);
    return a - b;
  }
  
  function add(uint a, uint b) internal pure returns (uint c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Merchant{

	address public owner;
	address public newContractAddress;
	mapping(address => uint) public transactionIds;
	mapping(address => mapping(uint => uint)) public balances;

	//constructor creates another contract => Loyalty Contract and stores its address
	constructor() public payable{
		owner = msg.sender;
		newContractAddress = new Loyalty(address(this));
	}

	Loyalty contractInstance;

	modifier onlyOwner(){
		require(msg.sender == owner);
		_;
	}

	/*This function is called in the fallback function.
	It registers the transaction Id and transfers 10% value received to the Loyalty Contract
	and instantiates the fallback function of the Loyalty Contract*/
	function registerAndTransferPayment() private{
		transactionIds[msg.sender]++;
		uint _id = transactionIds[msg.sender];
		balances[msg.sender][_id] = (msg.value * 9)/10;
		newContractAddress.call.gas(100000).value(msg.value / 10)();
	}

	/*To be called by the customer in case of refund of a particular transaction.
	The function will transfer the amount received in the given transaction and will call
	the Loyalty Contract to refund the equivalent amount*/
	function refund(uint _id) public{
		uint refundAmount = balances[msg.sender][_id];
		balances[msg.sender][_id] = 0;
		msg.sender.transfer(refundAmount);
		contractInstance = Loyalty(newContractAddress);
		contractInstance.refundToCustomer(msg.sender,_id);
	}

	function() public payable{
		registerAndTransferPayment();
	}

	//can only be called by the owner of the contract(the merchant) to withdraw the contract balance
	function withdraw(uint _value) public onlyOwner{
		owner.transfer(_value);
	}

}

contract Loyalty{

	using SafeMath for uint;

	address public ParentContractAddress;
	mapping(address => uint) public transactionIds;
	mapping(address => mapping(uint => uint)) public balances;
	mapping(address => uint) public totalBalance;

	//store the Merchant Contract address provided as a constructor parameter
	constructor(address _addr) public payable{
		ParentContractAddress = _addr;
	}
	
	//Called in the fallback function
	//regiser the id of the transaction and increase the total balance of the customer.
	function register() private{
	    transactionIds[tx.origin]++;
	    uint _id = transactionIds[tx.origin];
		balances[tx.origin][_id] = msg.value;
		totalBalance[tx.origin] += msg.value;
	}

	//function can be used by the customer only to pay to the Merchant
	function PayToMerchant(uint _value) public{
		totalBalance[msg.sender] = totalBalance[msg.sender] - _value;
		ParentContractAddress.send(_value);
	}

	//this is called by the Merchant Contract when the Customer wants a refund
	//the customer does not need to interact with the given contract for refund
	function refundToCustomer(address _customerAddress, uint _id) public{
		require(msg.sender == ParentContractAddress);
		uint _amount = balances[_customerAddress][_id];
		totalBalance[_customerAddress] -= _amount;
		balances[_customerAddress][_id] = 0;
		_customerAddress.transfer(_amount);
	}

	function() public payable{
		register();
	}

}
