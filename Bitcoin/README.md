## Solution using Bitcoin, built on the Test Regression Network. 
For three accounts, run three different nodes with three different configutation files
The accounts are Customer, Merchant, Loyalty wherein the Customer and the Loyalty accounts are both owned by the customer.\
Download bitcoin core from https://bitcoin.org/en/bitcoin-core/.\
In the bitcoin.conf file, add the following fields :
```
rpcuser={{user name}}
rpcpassword={{user password}}
addnode={{ip address of the peer nodes}}
```
Run the node with 
```
.\bitcoind
```
Node 1 : Customer Account
```
.\bitcoin-cli -regtest generate 119
```
This will generate 119 blocks and credit the account with 1000 bitcoins.\
Node 2 : Merchant Account
```
.\bitcoin-cli -regtest getnewaddress
```
Node 3 : Loyalty Account
```
.\bitcoin-cli -regtest getnewaddress
```
Node 1 : Customer Account
Perform 5 transactions
```
.\bitcoin-cli -regtest sendtoaddress "{{merchantaddress}}" {{value1}}
.\bitcoin-cli -regtest sendtoaddress "{{merchantaddress}}" {{value2}}
.\bitcoin-cli -regtest sendtoaddress "{{merchantaddress}}" {{value3}}
.\bitcoin-cli -regtest sendtoaddress "{{merchantaddress}}" {{value4}}
.\bitcoin-cli -regtest sendtoaddress "{{merchantaddress}}" {{value5}}
```
Node2: (Merchant Account):
```
.\bitcoin-cli -regtest sendtoaddress "{{Loyalty Account}}" {{10% of value}}
```
