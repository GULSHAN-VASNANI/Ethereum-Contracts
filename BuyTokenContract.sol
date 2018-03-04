/*
Contract which has following functions:
1. buyTokens - if someone calls this method and passes some ETH in the transaction, following checks are done:
 - check  if the sender is whitelisted. If sender is whitelisted, then the ETH which are transfered are passed on to a TRUSTEE address. If the sender is not whitelisted, then return error - such transaction should fail.

2. getWhitelistStatus - this method takes in an address and returns 0 / 1 depending on whether the address is whitelisted.

3. whitelist - this method takes in an address as an argument. Only one address - opsAddress should be able to call this method successfully. If someone else tries to call this method, it fails.
On success, this marks the address which was sent in the argument as whitelisted.
We also need event in whitelist method, with the address which was sent for whitelisting as one parameter.

4. unWhitelist - this method takes in an address as an argument. Only one address - opsAddress should be able to call this method successfully. If someone else tries to call this method, it fails.
On success, this marks the address which was sent in the argument as un-whitelisted.
We also need event in unWhitelist method, with the address which was sent for unWhitelisting as one parameter.

Note :- This is tested on remix ide.When calling buyTokens method on remix,put some value on the "vaule" field to transfer the ether to TRUSTEE Address.

*/
pragma solidity ^0.4.19;

contract BuyTokensContract {
    
    mapping(address => bool) statusOfAddress;
    event whiteListedAddress(address addressWhiteListed);
    event unWhitelistAddress(address addressUnWhiteListed);
    address opsAddress;
    address TRUSTEE;
    address contractCreator;
    
    //It is used to assign the creator of contract.
    function TokenGeneration() payable{
        contractCreator=msg.sender;
    }
    
    //It sets opsAddress and will be called only by owner of the contract.
    function setOpsAddress(address newOpsAddress) addressCheck(newOpsAddress) onlyContractCreator(msg.sender){
        opsAddress=newOpsAddress;
    }
    
    //It allows only the owner of the contract to set the TRUSTEE address.
    function setTrusteeAddress(address newTrusteeAddress) addressCheck(newTrusteeAddress) onlyContractCreator(msg.sender){
        TRUSTEE=newTrusteeAddress;
    }
    
    //It allows whitelisted addresses to buy tokens and upon successful verification of address the ether is send to the TRUSTEE address.
    function buyTokens() payable {
        
        require(getWhitelistStatus(msg.sender));
        TRUSTEE.send(msg.value);
        
    }
    
    //It checks whether the passed address is same as the opsAddress.
    modifier onlyOpsAddressAllowed(address check){
        if(opsAddress == check)
            _;
        else 
            revert();
    }
    
    //It is used to check whether the address passed is null or valid address.
    modifier addressCheck(address addressNullCheck){
        if(addressNullCheck != address(0))
        _;
    }
    
    //Modifier to check the address passed is the creator/owner of the contract.
    modifier onlyContractCreator(address owner){
        if(owner == contractCreator)
        _;
    }
    
    
    //It is used to set the status of an address so that it can buy tokens and will only be called by opsAddress.
    function whitelist(address addressToBeWhiteListed) addressCheck(addressToBeWhiteListed) onlyOpsAddressAllowed(msg.sender) {
        statusOfAddress[addressToBeWhiteListed]=true;
        whiteListedAddress(addressToBeWhiteListed);
    }
    
    //It is used to disallow the address passed to bu tokens.It will only be called by opsAddress.
    function unWhitelist(address addressToBeWhiteListed) addressCheck(addressToBeWhiteListed) onlyOpsAddressAllowed(msg.sender){
        statusOfAddress[addressToBeWhiteListed]=false;
        whiteListedAddress(addressToBeWhiteListed);
    }
    
    //It is used to get the status(true/false) of the address which are whitelisted i.e. allowed to buy tokens
    function getWhitelistStatus(address addressStatus) returns(bool){
        
        return statusOfAddress[addressStatus];
        
    }
    
}
