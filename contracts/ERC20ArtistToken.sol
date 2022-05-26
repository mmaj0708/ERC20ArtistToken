// SPDX-License-Identifier: VIBE inc.

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract ERC20ArtistToken is ERC20PresetMinterPauser, Ownable {
    
    address payable _artistAddr;
    uint256 artistFee = 0;
    uint256 vibeFee = 0;

    /*
        Vibe enterprise is the only deployer of artistic ERC20 token

        artistSupply : amount of tokens given to the artist at deployment. If ICO is not fullfilled, artist get the rest of tokens that were not bought
        vibeSupply : amount of tokens given to Vibe at deployment
    */

    constructor(string memory name, string memory symbol, address payable artistAddr, uint256 vibeSupply, uint256 artistSupply) ERC20PresetMinterPauser(name, symbol) {
        _mint(msg.sender, vibeSupply);
        _artistAddr = artistAddr;
        _mint(_artistAddr, artistSupply);
    }

    /*
    **  Only artist can modify his address on the contract
    */

    modifier onlyArtist {
        require(msg.sender == _artistAddr);
        _;
    }

    function setArtistAddr(address payable newArtistAddr) onlyArtist external returns(bool) {
        _artistAddr = newArtistAddr;
        return (true);
    }

    /*
    **  DO NOT USE THIS TRANSFER FUNCTION
    **  transfer function from ERC20 Token standard is overriden to be useless
    */

    function transfer(address to, uint256 amount) override public pure returns(bool) {
        amount = 0;
        address(to);
        return false;
    }

    /*
    **  THIS IS THE TRANSFER FUNCTION TO USE
    **  Transfer function from ERC20 Token standard is overriden to be useless
    **
    **  On each transfer call, part of the fee is sent to the artist, then Vibe
    */

    function transferTokens(address to, uint256 amount) external payable returns(bool) {
        payable(owner()).transfer(address(this).balance / 2);   // send ether to Vibe
        _artistAddr.transfer(address(this).balance / 2);        // send ether to the artist

        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    // setVibeFee() onlyOwner
    // setArtistFee() onlyOwner
}

// timed crowdsale contract !
// voir le contrat is ownable.sol