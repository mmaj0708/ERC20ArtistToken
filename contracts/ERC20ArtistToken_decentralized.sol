// SPDX-License-Identifier: VIBE inc.

/*
**  Vibe enterprise is the only deployer of Artistic ERC20 token
*/

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract ERC20ArtistToken is ERC20PresetMinterPauser, Ownable {
    
    struct artistIdentity {
        address artistAddr;        /* Wallet address of the artist MODIFIABLE */
        string  artistName;        /* Pseudonyme of the artist NOT MODIFIABLE */
        string  realName;          /* Real name of the artist NOT MODIFIABLE */
        string  realFirstName;     /* Real first name of the artist NOT MODIFIABLE */
        string  birthDay;          /* BirthDay of the artist (format dd/mm/yyyy) NOT MODIFIABLE */
        string  bio;               /* Bio of the artist MODIFIABLE LIMITED TO 300 CHARACTERES */
        // string  picture;   /* link of the picture of the artiste MODIFIABLE */
    }

    artistIdentity _artist;

    /*
    **  @dev
    **  artistSupply : amount of tokens given to the artist at deployment. If ICO is not fullfilled, artist get the rest of tokens that were not bought
    **  vibeSupply : amount of tokens given to Vibe at deployment
    */

    constructor(
        string memory name,
        string memory symbol,
        address artistAddr,
        string  memory artistName,
        string  memory realName,
        string  memory realFirstName,
        string  memory bio,
        uint256 vibeSupply,
        uint256 artistSupply
    ) ERC20PresetMinterPauser(name, symbol) {
        _artist.artistAddr = artistAddr;
        _artist.artistName = artistName;
        _artist.realName = realName;
        _artist.realFirstName = realFirstName;
        _artist.bio = bio;
        _mint(msg.sender, vibeSupply);
        _mint(_artist.artistAddr, artistSupply);
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    /*
    **  @dev Only artist can modify his address on the contract
    */

    modifier onlyArtist {
        require(msg.sender == _artist.artistAddr, "Caller is not the artist");
        _;
    }

    /*
    ** @dev Transfers Artist account to a new account (`newArtist`).
    ** Can only be called by the current Artist account.
    */
    function transferArtistAddr(address newArtistAddr) public virtual onlyArtist {
        require(newArtistAddr != address(0), "new artist is the zero address");
        _artist.artistAddr = newArtistAddr;
    }

    /*
    ** @dev Modify bio of the Artist account (`newBio`).
    ** Can only be called by the current Artist account.
    */
    function modifyBio(string memory newBio) public virtual onlyArtist {
        _artist.bio = newBio;
    }

    /*
    ** @dev return .
    */
    function artist() public view virtual returns (artistIdentity memory) {
        return _artist;
    }

}

// timed crowdsale contract !
// Do I use a different decimal ?