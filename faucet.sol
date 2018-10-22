pragma solidity ^0.4.18;
contract faucet{
    
    uint time = now;
     
     struct user{
        uint lastUpdated;
        address userAddress;
    }
    
    user[] public users;
    
    mapping (address => uint) userRequestTime;
    
    event newRequest (address _users, uint _value);
    event userDonate(address _users, uint _value);
    
    
    
    function isContract(address addr) public view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
    
    function requestToken(address wallet) public returns (bool) {
        if (userRequestTime[wallet] < now + 10 seconds){
            uint _value = 1 ether;
            require(_value <= address(this).balance);
            if(!isContract(msg.sender)){
                wallet.transfer(_value);
                users.push(user(now,wallet));
                userRequestTime[wallet] = now;
                emit newRequest(wallet,1 ether);
                return true;
            }
            
        }
        return false;
    }
    
    function getBalance() public view returns (uint256) {
    return address(this).balance;
  }
    
    function () payable public {
        require(msg.value > 0);
        emit userDonate(msg.sender,msg.value);
       
    }
}
