# Star Coins for Super Mario World

This is a resource pack to add in the Star Coins from the New Super Mario Bros series to Super Mario World.
In short, they're basically Dragon Coins but improved in which they're kept track of individually instead
of the game treating them as one and the same (in turn, the player isn't required to collect them in one
go).

The coins come in the sizes 16x16 (same size as a small coin), 16x32 (appearing like a Dragon Coin) and
32x32 (comparable to their appearance).

For a more detailed instruction, please refer to [this](docs/main.html) documentation.

## Folder Layout

- `docs` contains the extended readme with instructions, coding information and images
- `ExGraphics` contains all the necessary files
- `gps` includes all the files necessary for the Star Coin blocks
- `objectool` includes all the files necessary to use Star Coins with Objectool.
- `patches` is the folder where the main patch as well as the main defines are located.
  - `sram_plus` and `bwram_plus` are both folders where you put in `sram_plus.asm` and `bwram_plus.asm`
    respectively. `star_coins.asm` will automatically insert either patch if the files are located
	into their folders.
- `uberasm` is all the files necessary for UberASM and contain the main handler of the Star Coins.

## Changelog

If you want to see the changelog, please refer to (CHANGELOG.md).

## Contributors

- LX5 (original creator, owner)
- MarioFanGamer (remoderation, primary maintainer)
- Blind Devil
