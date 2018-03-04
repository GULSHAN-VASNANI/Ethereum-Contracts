/*Gulshan
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
