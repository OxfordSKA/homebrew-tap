# Homebrew Tap

## Getting started

To use the forumlas provided here with your homebrew installation:

```bash
brew tap OxfordSKA/homebrew-tap
```

To remove:

```bash
brew untap OxfordSKA/homebrew-tap
```

## Updating forumla

Replace the url and generate a new sha256 with

```bash
shasum -a 256 <file>
```

## Creating and updating bottles

To create a new bottle:

```bash
brew install --build-bottle <forumla>
brew bottle <formula>
```
