**Prompt**

Using the below code snippet, create the question in a manner where it explains what each function should do. Include hints for each questions asked.

**Question:**

Consider the `FundMe` smart contract, which is designed to facilitate funding and withdrawal of funds. The contract includes several key functions and features.

1. **Constructor Function:**
   - What does the constructor function do in the `FundMe` contract?
   - Hint: The constructor function is a special function that is executed only once when the contract is deployed. It sets the `i_owner` variable to the address that deploys the contract.

2. **Fund Function:**
   - Explain the purpose and functionality of the `fund` function. How does it ensure that the minimum funding requirement is met?
   - Hint: The `fund` function allows users to send Ether to the contract. It checks if the sent amount is at least $5 USD worth of Ether using the `PriceConverter` library. If the condition is met, the sender's address is added to the `listOfFunders` array, and the amount funded is recorded in the `addressToAmountFunded` mapping.

3. **Withdraw Function:**
   - Describe the role of the `withdraw` function. How does it handle the transfer of funds to the owner? What are the differences between the commented-out transfer methods and the active low-level `.call` method used for transferring funds?
   - Hint: The `withdraw` function is designed to allow the owner of the contract to withdraw all the funds. It iterates over the `listOfFunders` array, resets the amount funded by each funder to zero, and then clears the `listOfFunders` array. Finally, it transfers the entire balance of the contract to the owner using a low-level `.call` method.

4. **OnlyOwner Modifier:**
   - What is the purpose of the `onlyOwner` modifier in the `withdraw` function? How does it restrict access to the function?
   - Hint: The `onlyOwner` modifier is used to restrict the `withdraw` function so that only the owner of the contract can call it. It checks if `msg.sender` is the owner before proceeding with the withdrawal.

5. **PriceConverter Library:**
   - How does the `PriceConverter` library contribute to the functionality of the `fund` function?
   - Hint: The `PriceConverter` library is used within the `fund` function to convert the amount of Ether sent to the contract into its equivalent value in USD. This is done using the `getConversionRate` method, which is called on the `msg.value` to ensure that the minimum funding requirement is met.

6. **Receive and Fallback Functions:**
   - Explain the use of the `receive` and `fallback` functions in the contract. How do they interact with the `fund` function to handle incoming transactions?
   - Hint: The `receive` and `fallback` functions are special functions that handle incoming Ether transactions without a specific function call. They call the `fund` function to allow users to fund the contract by simply sending Ether to the contract's address.

7. **Immutable Keyword:**
   - What is the significance of the `immutable` keyword in the declaration of `i_owner`, and how does it contribute to gas optimization?
   - Hint: The `immutable` keyword is used to declare the `i_owner` variable, which stores the address of the contract's owner. This keyword ensures that the value of `i_owner` cannot be changed after the contract is deployed, which is useful for gas optimization and ensuring the integrity of the contract's owner.
