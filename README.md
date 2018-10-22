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

