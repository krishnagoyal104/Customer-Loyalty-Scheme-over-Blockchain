var MyContract1 = artifacts.require("Merchant");
var MyContract2 = artifacts.require("Loyalty");

module.exports = function(deployer) {
	deployer.deploy(MyContract1); 
};