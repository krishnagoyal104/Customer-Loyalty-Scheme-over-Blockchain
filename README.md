# Customer-Loyalty-Scheme-over-Blockchain
A Loyalty Reward system implemented using Contracts on Blockchain

## Details :
* The **Customer** Account is owned by the customer while the **Merchant** and **Loyalty** accounts are Contracts deployed by the merchant.
* Whenever the customer makes any payment to the Merchant, **90%** is stored in the Merchant Account and the remaining **10%** is sent to the Loyalty account.
* The balance in the **Loyalty** Account can be used by the Customer to **only pay to the Merchant** and for no other use. (Basically Credits that can be spent only with the Merchant.)
* If the customer wants a **refund**, he can call the refund function in the Merchant Contract, specifying the **Id of the transaction** which he wants to refund.
* The Merchant Contract will refund the 90% that it holds and the rest 10% will be refunded by the Loyalty Account immediately. (The Merchant Contract will call the loyalty contract)
* The Merchant can **withdraw the balance** from the Merchant Contract to any other address.

### Updates :
* The Merchant Contract can now manage multiple customer accounts.
### Bug Fixes
* Re-entrancy disabled.
* Underflow vulnerability removed.

## Running the Solution :
Create the customer account.
```
> geth --datadir accounts account new
```
Copy and paste the generated address to the 'alloc' field of `genesis.json`. This will pre-allocate 1000 ethers to the customer account.
```
> geth --datadir data init genesis.json
```
Run the node.
```
> geth --datadir data --rpc --rpcapi="personal,web3,eth,admin,miner,net,txpool" --networkid 15
```
Copy and paste the UTC file generated from `geth` into `data/keystore` so that it is accessible from the `geth` console.\
\
Create the geth console in a new terminal.
Create a new account to deploy the merchant contract and give it some gas.
```
> geth attach http://localhost:8545
> personal.newAccount()                   
> personal.unlockAccount(eth.accounts[1])
> miner.start()
> miner.setEtherbase(eth.accounts[1])     
```
Deploying the contract:
* In `truffle.js`, change the 'from' field to the new address created using the geth console.
* In a new terminal :
```
> cd truffle
> truffle migrate
> truffle console
```
Get the address of the contract :
```
> Merchant.address
```
From the geth console, send transactions from Customer account to Merchant account.
```
eth.sendTransaction({from:eth.accounts[0], to:"{{contractAddress}}", value:web3.toWei(10, "ether")})
```
Call for refund from the geth console:
```
abi = <abi from the abi.js file>
var myContract = abi.at({{contractAddress}});
var getData = myContract.refund(_id)
eth.sendTransaction({from:eth.accounts[0], to:"{{contractAddress}}"}, data: getData)
```

