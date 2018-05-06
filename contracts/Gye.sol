pragma solidity ^0.4.18;

// Ethereum Gye(契) Contract
// Jeong Yeop (Terence) Kim

contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}


// Simple Gye
contract Gye is owned {
  Member[] public members;
  mapping (address => uint) public memberDirectory;
  string public gyeName;
  string public gyeDescription;
  uint public interest;

  struct Member {
    bool exists;
    address member;
    string name;
    uint deposit;
    bool deposited;
    bool withdrawn;
  }

  constructor(string _gyeName, string _gyeDescription, uint _interest) public {
    gyeName = _gyeName;
    gyeDescription = _gyeDescription;
    members.push(Member({exists: false, member: 0, name: "SENTINEL", deposit: 0, deposited: false, withdrawn: false})); // sentinel
    memberDirectory[msg.sender] = members.length;
    members.push(Member( { exists: true,
                                            member: msg.sender,
                                            name: "Owner",
                                            deposit: 0,
                                            deposited: false,
                                            withdrawn: false }));
    interest = _interest;
  }

  function addMember(address memberAddress, string memberName) onlyOwner public {

    memberDirectory[memberAddress] = members.length;
    members.push(Member({ exists: true,
                                member: memberAddress,
                                name: memberName,
                                deposit: 0,
                                deposited: false,
                                withdrawn: false }));
  }

  modifier onlyMember {
      require(members[memberDirectory[msg.sender]].exists);
      _;
  }

  function pay(address recepient, uint amount) onlyOwner public {
    recepient.transfer(amount);
  }

  // https://github.com/Giveth/vaultcontract/blob/master/contracts/Vault.sol
  event EtherReceived(address indexed from, uint amount);
  //////
  // Receive Ether
  //////

  /// @notice Called anytime ether is sent to the contract && creates an event
  /// to more easily track the incoming transactions
  function receiveEther() onlyMember public payable {
    address sender = msg.sender;
    uint value = msg.value;

    Member memory member = members[memberDirectory[sender]];
    member.deposited = true;
    member.deposit += value;

    emit EtherReceived(sender, value);
  }

  /// @notice The fall back function is called whenever ether is sent to this
  ///  contract
  function () public payable {
    receiveEther();
  }


}
