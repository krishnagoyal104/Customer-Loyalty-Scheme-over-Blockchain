pragma solidity ^0.4.20;

contract Merchant{

	address public owner;
	address public newContractAddress;
	uint8 id = 0;
	mapping(uint8 => uint) public balances;


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
	function registerAndTransferPayment() public payable{
		id++;
		balances[id] = (msg.value * 9) / 10;
		newContractAddress.call.value(msg.value / 10)();
	}

	/*To be called by the customer in case of refund of a particular transaction.
	The function will transfer the amount received in the given transaction and will call
	the Loyalty Contract to refund the equivalent amount*/
	function refund(uint8 _id) public{
		msg.sender.transfer(balances[_id]);
		balances[_id] = 0;
		contractInstance = Loyalty(newContractAddress);
		contractInstance.refundByCustomer(msg.sender,_id);
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

	address public ParentContractAddress;
	mapping(uint8 => uint) balance;
	uint8 public _id;

	//store the Merchant Contract address provided as a constructor parameter
	constructor(address _addr) public payable{

		ParentContractAddress = _addr;
		_id = 0;

	}
	
	//Called in the fallback function
	//regiser the transaction id of the transaction.
	function register() private{
	    _id++;
		balance[_id] = msg.value;
	}

	//function can be used by the customer only to pay to the Merchant
	function PayToMerchant(uint _value) public{
		ParentContractAddress.transfer(_value);
	}

	//this is called by the Merchant Contract when the Customer wants a refund
	//the customer does not need to interact with the given contract for refund
	function refundByCustomer(address _customerAddress, uint8 _Id) public{
		require(msg.sender == ParentContractAddress);
		_customerAddress.transfer(balance[_Id]);
	}

	function() public payable{
		register();
	}

}
