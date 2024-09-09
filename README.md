# setup-hledger

[![Test](https://github.com/ngalaiko/setup-hledger/actions/workflows/test.yaml/badge.svg)](https://github.com/ngalaiko/setup-hledger/actions/workflows/test.yaml)

This action can be used to setup hledger binaries.

## Usage

See [action.yaml](action.yaml)

**Basic:**

```yaml
steps:
- uses: actions/checkout@v3
- uses: ngalaiko/setup-hledger@v1
- run: |
    hledger --version
```

**Specific version:**

```yaml
steps:
- uses: actions/checkout@v3
- uses: ngalaiko/setup-hledger@v1
  with:
    version: 1.28
- run: |
    hledger --version
```

The `version` input is optional. If not supplied, the latest available release will be used.

### Supported versions

All the versions [released on GitHub](https://github.com/simonmichael/hledger/releases) are supported.

### Supported runners

* ubuntu-latest
* macos-latest

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE)
