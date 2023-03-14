// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GNaria is ERC20{
    mapping(address => uint256) private _balances;
    address payable public governor;
    mapping(address=>bool) isBlacklisted;
    // event _Alltranscation(address to, uint amount);
    // event _AlltransferToken(address from, address to, uint amount);

    constructor() ERC20("GNARIA", "NGNG"){
        governor = payable(msg.sender);

    }
    modifier onlyGovernors() {
        require(msg.sender == governor);
        _;
    }

    // Mint:
    function minting(uint256 amount) public onlyGovernors {
       _mint(msg.sender, amount);
    }

    // Function for Burning :
    function Burning( uint256 amountToBurn) public onlyGovernors {
        _burn(msg.sender, amountToBurn);
    }

    // Function for blacklisting :
    function blacklisting(address user) public onlyGovernors {
        require(!isBlacklisted [user], "~~user already blacklisted~~");
        isBlacklisted[user] = true;
        // emit events as well
    }

   
    // Function for Removing from blacklisting :
    function removeFromBlackList(address user) public onlyGovernors {
        require(isBlacklisted [user], " ~~user already whitelisted~~");
        isBlacklisted[user] = false;
        // emit events as well
    }

    function _beforeTokenTransfer(address _sender, address _reciever, uint256 value) internal virtual override checkBlacklist(_sender, _reciever){
       super._beforeTokenTransfer(_sender, _reciever, value * 10 ** 18);
    }

    modifier checkBlacklist(address from, address to) {
        require(!isBlacklisted[to], "~~Reciever is backlisted~~");
        require(!isBlacklisted[from], "~~Sender is backlisted~~");
        _;
    }

  
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount * 10 ** 18);
            }
        }
    }


    //  Checking If User Is BlackListed:
    function _isBlacklisted(address user) public view returns (bool) {
     return isBlacklisted[user];
    }

    // Increase Allowance:
     function increaseAllowance(address spender, uint256 addedValue) public override virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue * 10 ** 18);
        return true;
    }

    // Decrease Allowance:
     function decreaseAllowance(address spender, uint256 subtractedValue) public override virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue * 10 ** 18);
        }

        return true;
    }

    // Transfer :
      function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount *10 ** 18);
        _transfer(from, to, amount);
        return true;
    }


}

