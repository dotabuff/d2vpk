# This repository is deprecated!

Due to changes in the Dota 2 Reborn client, we took the opportunity to improve aspects of d2vpk.
As a result, a new repository has been created over at [dotabuff/d2vpkr](https://github.com/dotabuff/d2vpkr).

Please note that the new respository has a different folder structure and many files that aren't
being referenced in our projects are no longer available to reduce the size of the new repository.

This repository will remain live for the time being and we encourage all users to move to d2vpkr. 
If there is something missing in d2vpkr, please file an issue on the d2vpkr project and let us know.

**This repository will no longer be updated.** d2vpk remains so that existing projects will not break.

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
