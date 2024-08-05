# Changelog

## [19.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v18.0.0...v19.0.0) (2024-08-05)


### ⚠ BREAKING CHANGES

* **renderer:** Added support for simple html elements
* **renderer:** Support for tables that don't start at the start of the line

### Features

* Added support for HTML entites ([3b270c1](https://github.com/OXY2DEV/markview.nvim/commit/3b270c1dedbf02b4849341ff9e490a001041e248))
* **renderer:** Added basic language names to code blocks ([c9b4f77](https://github.com/OXY2DEV/markview.nvim/commit/c9b4f77e880eb0ab9afd370ad82e3758513a4a3a)), closes [#72](https://github.com/OXY2DEV/markview.nvim/issues/72)
* **renderer:** Added better validation for html tags in table cells ([ab0e54e](https://github.com/OXY2DEV/markview.nvim/commit/ab0e54e2992b3806fe2b3a68a49d050f1118159e))
* **renderer:** Added hybrid-mode support to the plugin ([4a93e15](https://github.com/OXY2DEV/markview.nvim/commit/4a93e155261508b89d5c6146ba6cc0da91be0883)), closes [#64](https://github.com/OXY2DEV/markview.nvim/issues/64)
* **renderer:** Added support for simple html elements ([94ce522](https://github.com/OXY2DEV/markview.nvim/commit/94ce522302f78167e278d3c7d82ff0206c74b4e3))
* **renderer:** Support for tables that don't start at the start of the line ([3c8b0dc](https://github.com/OXY2DEV/markview.nvim/commit/3c8b0dc5a9b02264f94137b23279db7d3198ac7a))
* replace tbl_islist to islist ([f1e66c7](https://github.com/OXY2DEV/markview.nvim/commit/f1e66c78ba28b3b2399a4b76febc42ceb3211fd1))


### Bug Fixes

* **parser:** Added logic for supporting markers inside code blocks ([a38dd1f](https://github.com/OXY2DEV/markview.nvim/commit/a38dd1f01c31b4201b4355fe8ebaa439621e5b35)), closes [#69](https://github.com/OXY2DEV/markview.nvim/issues/69)
* **parser:** Improved validation of pending checkboxes ([a6392dd](https://github.com/OXY2DEV/markview.nvim/commit/a6392ddeb627a4ebd218718bc4f80b5fca1a1803))
* **renderer:** Fixed a bug causing inconsistency between the left & right padding in inline codes ([0eb84e5](https://github.com/OXY2DEV/markview.nvim/commit/0eb84e5721dfd2ded1c598eba3ec018d5fd1cd9d))
* **renderer:** Fixed a bug causing the last line to have border placed on the wrong column ([e102b06](https://github.com/OXY2DEV/markview.nvim/commit/e102b060907173fcafaa8e5e4edde993452a9808))
* **renderer:** Fixed a bug leading to extmarks on the current line not being removed ([777c6aa](https://github.com/OXY2DEV/markview.nvim/commit/777c6aa50d623eed5a17fb39be60f23fbc7bd4bc))
* **renderer:** Fixed screen not updating in "no" mode ([60bc13b](https://github.com/OXY2DEV/markview.nvim/commit/60bc13b9492570d4d321391517eb9677918f540e)), closes [#70](https://github.com/OXY2DEV/markview.nvim/issues/70)
* **renderer:** Made headings use decorations around the text instead of replacing the main text ([41d57ab](https://github.com/OXY2DEV/markview.nvim/commit/41d57ab40603b702cd7b7b920c71f7b20ba202aa))
