// SPDX-License-Identifier: VIBE inc.

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract ERC20ArtistToken is ERC20PresetMinterPauser {
    
    address _artistAddr;
    uint256 artistFee = 0;
    uint256 vibeFee = 0;

    /*
        Vibe is the only deployer of artistic ERC20 token

        artistSupply : amount of tokens given to the artist at deployment. If ICO is not fullfilled, artist get the rest of tokens that were not bought
        vibeSupply : amount of tokens given to Vibe at deployment
    */

    constructor(string memory name, string memory symbol, address artistAddr, uint256 vibeSupply, uint256 artistSupply) ERC20PresetMinterPauser(name, symbol) {
        _mint(msg.sender, vibeSupply);
        _artistAddr = artistAddr;
        _mint(_artistAddr, artistSupply);
    }

    /*
        Only artist can change his address on the contract
    */
    // setArtistAddr() onlyArtist()

    // timed crowdsale contract !

    /*
        On each transfer call, part of fees goes to artist, then Vibe
    */
    // transferToEveryone()

    // setVibeFee() onlyOwner
    // setArtistFee() onlyOwner
}
