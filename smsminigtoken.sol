pragma solidity ^0.4.13;

/**
 *Submitted for verification at Etherscan.io on 2019-06-12
*/

/*This contract was created for Vomer.
*https://vomer.net/
*Vomer is not just an instant messenger.
*Vomer is a lot. If not all.
* 
*This file is part of the Deviser Contract.

*The Deviser Contract is free software: you can redistribute it and/or
*modify it under the terms of the GNU lesser General Public License as published
*by the Free Software Foundation, either version 3 of the License, or
*(at your option) any later version.

*The Deviser Contract is distributed in the hope that it will be useful,
*but WITHOUT ANY WARRANTY; without even the implied warranty of
*MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*GNU lesser General Public License for more details.

*You should have received a copy of the GNU lesser General Public License
*along with the Deviser Contract. If not, see <http://www.gnu.org/licenses/>.
*
*
*Designed by @136789wise
*/



contract owned {
    address public owner;
    address public newOwner;

    function owned() payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address _owner) onlyOwner public {
        require(_owner != 0);
        newOwner = _owner;
    }
    
    function confirmOwner() public {
        require(newOwner == msg.sender);
        owner = newOwner;
        delete newOwner;
    }
}

contract Crowdsale is owned {
    
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function Crowdsale() payable owned() {
        totalSupply = 500000000;
        balanceOf[this] = 500000000;
        balanceOf[owner] = totalSupply - balanceOf[this];
        Transfer(this, owner, balanceOf[owner]);
    }

    function () payable {
        require(balanceOf[this] > 0);
        uint256 tokensPerOneEther = 250;
        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
        if (tokens > balanceOf[this]) {
            tokens = balanceOf[this];
            uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
            msg.sender.transfer(msg.value - valueWei);
        }
        require(tokens > 0);
        balanceOf[msg.sender] += tokens;
        balanceOf[this] -= tokens;
        Transfer(this, msg.sender, tokens);
    }
}

contract EasyToken is Crowdsale {
    
    string  public standard    = 'Sms Mining Ethereum';
    string  public name        = 'SmsMiningToken';
    string  public symbol      = "SMT";
    uint8   public decimals    = 0;

    function EasyToken() payable Crowdsale() {}

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }
}

contract SmsMiningTokenOn is EasyToken {

    function SmsMiningTokenOn() payable EasyToken() {}
    
   
    function withdraw_all() public onlyOwner {
        owner.transfer(this.balance);
    }
    
    function killMe() public onlyOwner {
        selfdestruct(owner);
    }
}
