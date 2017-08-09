# Github Archivize

A simple `bash` + `curl` + `jq` script that:

1. Fetches names of all repositories of a user given as a parameter,
2. Clones all of them separately to the `./.tmp` subdirectory
3. Uses `7za` to compress each of the cloned directory to a separate archive
4. Deletes the `./.tmp` subdirectory

The goal is to have a backup of all public repositories of a given user.

## Usage

```bash
./github-archivize.sh USERNAME
```
