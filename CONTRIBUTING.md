# Contributing

Thanks for helping improve Clicked Relative Position.

The whole tool is one file, `index.html`. Styles and script live inline,
and there is nothing to install or build. To try a change, open the file in
a browser, or run `make serve` and visit the local address it prints.

The most useful reports describe a real click that came out wrong. Say
which units and origin you had selected, where you clicked, and what the
log showed against what you expected. If you attach an export, edit out
anything you would rather keep private first: it records your screen size,
your window position and the time of each click.

When changing the page, keep it dependency-free and keep every measurement
local, so the page never sends data anywhere. Wording in the interface and
the docs stays generic, so please describe tools and platforms by what they
do instead of by product name. Keep code, comments and documentation in
English.

If your change affects what the page looks like, regenerate the README
images with `make shots`. The figure sources sit in `docs/figures/`, and
`make figures` rebuilds their images.

Please follow the [Code of Conduct](./CODE_OF_CONDUCT.md) in all project
spaces.
