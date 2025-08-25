# gh-automerge

**gh-automerge** is a GitHub CLI extension to enable auto-merge on a pull request.

## Prerequisites

- [GitHub CLI](https://cli.github.com/) installed and authenticated

## Install

```bash
gh extension install EricCrosson/gh-automerge
```

## Use

```bash
gh automerge [<number> | <url> | <branch>]...
```

You can provide multiple pull requests to process them sequentially:

```bash
gh automerge 123 456
```

## License

Licensed under either:

- [MIT License](https://opensource.org/licenses/MIT)
- [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this project by you shall be dual licensed as above, without
any additional terms or conditions.
