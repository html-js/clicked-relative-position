# Changelog

This file records what changed in each release. It follows the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) style, and version
numbers follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-10-31

First public release. The tool ships as a single dependency-free page that
records the position of every click relative to a box, in CSS pixels,
percent, 0 to 1 fractions or device pixels, with a choice of origin.

Clicks become numbered, draggable marks with an undoable history. A local
background image can be measured in its own pixels. The log exports to JSON
or CSV, and a portable record per point carries the box-relative fraction
along with ready-made snippets to place it again elsewhere. Panel stages go
down to a full-page mode in which the whole window records clicks, and the
chosen stage is kept in the address.

Product names were removed from the interface text and the export field
names in favor of generic terms, and the font stacks now name only generic
system families.

[0.1.0]: https://github.com/html-js/clicked-relative-position/releases/tag/v0.1.0
