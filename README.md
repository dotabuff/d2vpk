# Dota 2 VPK History

In this repository, we extract the contents of [Valve Pak](https://developer.valvesoftware.com/wiki/VPK) archives found in the Dota 2 client.
We also convert a number of important [VDF](https://developer.valvesoftware.com/wiki/KeyValues) files to JSON and store them in the `/json` directory.
Updates are commited automatically shortly after they are available in the client.

Due to GitHub space restrictions, files with these extensions are excluded:
`.wav`, `.vtf`, `.mp3`, `.mdl`, `.usm`, `.vvd`, `.dds`, `.webm`

## Setup

    make build

## Update

    make

## License

The source code in the root directory is © [Elo Entertainment LLC.] and under MIT license.
The contents of files in extracted directories are © [Valve Corporation](http://www.valvesoftware.com/).
