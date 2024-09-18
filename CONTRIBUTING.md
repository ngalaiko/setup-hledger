# contributing

thank you for considering contributing to this repo!

## support new version

1. add installation instructions to [install.sh][]  for both linux and darwin operating systems.
2. make sure that `version` variable in [install.sh][] is set to the latest available version>
3. add tests to [test.yaml][] for the new version

## release new version

1. make a new tag with the latest version name it's supports. for example, v1.40.0 for hledger version 1.40.0
2. update major tag to point to the latest version. for example, if you add v1.40.0, v1 must be updated to point to v1.40.0.
3. create a github release from the latest tag. v1.40.0 in this example.

[install.sh]: ./src/install.sh
[test.yaml]: ./.github/workflows/test.yaml
