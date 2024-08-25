# Changelog

## [21.0.1](https://github.com/OXY2DEV/markview.nvim/compare/v21.0.0...v21.0.1) (2024-08-25)


### Bug Fixes

* Fixed a bug causing markview to not render on cursor move in large files ([eba9507](https://github.com/OXY2DEV/markview.nvim/commit/eba950746173f8443b79b0b334f0c6a5d5797b55))
* Markview now assumes window width of the buffer. ([ec92e61](https://github.com/OXY2DEV/markview.nvim/commit/ec92e611419ca603aa0f1ae21ec159a7b4b82a54)), closes [#126](https://github.com/OXY2DEV/markview.nvim/issues/126)
* Markview now updats when entering the attached buffer ([87badab](https://github.com/OXY2DEV/markview.nvim/commit/87badab362d692025e717042c2ac052e7ff69fca)), closes [#126](https://github.com/OXY2DEV/markview.nvim/issues/126)
* Reduced flickering when scrolling short distances ([a1923f9](https://github.com/OXY2DEV/markview.nvim/commit/a1923f9a3ef6c0843eb95168c1ee510e2e6c86ab))

## [21.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v20.1.0...v21.0.0) (2024-08-25)


### ⚠ BREAKING CHANGES

* Deprecated old presets

### Features

* Added alignment support for `label` headings ([2e0761e](https://github.com/OXY2DEV/markview.nvim/commit/2e0761ef44ffcd863898309509b5b40103aeb9c9)), closes [#124](https://github.com/OXY2DEV/markview.nvim/issues/124)
* Added support for custom hyperlinks ([03188a4](https://github.com/OXY2DEV/markview.nvim/commit/03188a4658f0c0fdc0b9dc0f9926eb4c393ca97a)), closes [#121](https://github.com/OXY2DEV/markview.nvim/issues/121)


### Bug Fixes

* Deprecated old presets ([2e0761e](https://github.com/OXY2DEV/markview.nvim/commit/2e0761ef44ffcd863898309509b5b40103aeb9c9))
* Fixed a bug causing patterns to be matched inside inline codes ([1193286](https://github.com/OXY2DEV/markview.nvim/commit/119328617657e90e775934dd53ffd6b31aae988f))
* Plugin now recognizes escaped columns ([28c70aa](https://github.com/OXY2DEV/markview.nvim/commit/28c70aa40554963cb79de80286f956edc3181bff))

## [20.1.0](https://github.com/OXY2DEV/markview.nvim/compare/v20.0.0...v20.1.0) (2024-08-21)


### Features

* Added custom checkbox states ([ff96638](https://github.com/OXY2DEV/markview.nvim/commit/ff96638f94b52a293f8479a5b99b04d583c2c4b2)), closes [#117](https://github.com/OXY2DEV/markview.nvim/issues/117)

## [20.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v19.0.0...v20.0.0) (2024-08-20)


### ⚠ BREAKING CHANGES

* **renderer:** Added experimental support for lists inside block elements

### Bug Fixes

* Added experimental support for aligned checkbox desvription ([f9aba72](https://github.com/OXY2DEV/markview.nvim/commit/f9aba72c8d35ebe11eee7b4a4d7b10e92f18ec06)), closes [#107](https://github.com/OXY2DEV/markview.nvim/issues/107)
* Added option to change the indent size of list items ([d54039e](https://github.com/OXY2DEV/markview.nvim/commit/d54039e57fc6b263775a78473569f01224e2ddee)), closes [#96](https://github.com/OXY2DEV/markview.nvim/issues/96)
* Added the ability to open &lt;cfile&gt; links under cursor ([7f4639a](https://github.com/OXY2DEV/markview.nvim/commit/7f4639a53b3e3aac3ad5deab99b21097264f07cc)), closes [#97](https://github.com/OXY2DEV/markview.nvim/issues/97)
* Fixed a big casuing hybrid mode to become active on mode change ([15a49b5](https://github.com/OXY2DEV/markview.nvim/commit/15a49b532f2d79471db2c3ac2ee56e974ffb1dd4))
* Fixed a big causing highlight groups to not apply on empty config table ([1dd1d30](https://github.com/OXY2DEV/markview.nvim/commit/1dd1d3069d7f25ebefbeaf692af9f792e3414eab))
* Fixed a bug causing `callbacks` to not work on some functions ([a8e104b](https://github.com/OXY2DEV/markview.nvim/commit/a8e104badcc77534f3b4db2310545c70e28a890b)), closes [#104](https://github.com/OXY2DEV/markview.nvim/issues/104)
* Fixed a bug causing the `on_mode_changed()` callback to not fire ([cb7570b](https://github.com/OXY2DEV/markview.nvim/commit/cb7570be20acb3ad191385dee55db4e304bba42b))
* **gx:** Fixed a bug causing gx to not work with links. ([6d0bcce](https://github.com/OXY2DEV/markview.nvim/commit/6d0bcce3a74b10bcc79c04c5944bfc000381be49)), closes [#97](https://github.com/OXY2DEV/markview.nvim/issues/97)
* Made tables compatible with multi-col characters ([03290ce](https://github.com/OXY2DEV/markview.nvim/commit/03290ce2e0c9e426c53dc9a1efabd8a6ee1f4904)), closes [#42](https://github.com/OXY2DEV/markview.nvim/issues/42)
* **parser:** Added support for extra info on the code block start line ([7e0ad40](https://github.com/OXY2DEV/markview.nvim/commit/7e0ad400638b09205079693eb73307580f6303f3)), closes [#77](https://github.com/OXY2DEV/markview.nvim/issues/77)
* **parser:** Added support for labels in links ([1fc5d90](https://github.com/OXY2DEV/markview.nvim/commit/1fc5d90dbe6f8a171443b50875f7bbd794fdd607))
* Removed auto setting conceallevel & concealcursor ([798fd99](https://github.com/OXY2DEV/markview.nvim/commit/798fd991f5d163ed676877e87d8c65dc2d886cb9))
* Removed debug print for luminosity ([798fd99](https://github.com/OXY2DEV/markview.nvim/commit/798fd991f5d163ed676877e87d8c65dc2d886cb9)), closes [#101](https://github.com/OXY2DEV/markview.nvim/issues/101) [#102](https://github.com/OXY2DEV/markview.nvim/issues/102)
* **renderer:** `[]` are now counted when rendering tables ([c4f3d54](https://github.com/OXY2DEV/markview.nvim/commit/c4f3d544bd67b4ac0ebacc72091556841e81ca8b)), closes [#75](https://github.com/OXY2DEV/markview.nvim/issues/75)
* **renderer:** Added debounce to ModeChanged event ([c9fa106](https://github.com/OXY2DEV/markview.nvim/commit/c9fa1065098663c3bfe7e07656937c3d2f3dabea)), closes [#99](https://github.com/OXY2DEV/markview.nvim/issues/99) [#98](https://github.com/OXY2DEV/markview.nvim/issues/98)
* **renderer:** Added experimental support for lists inside block elements ([81c64a8](https://github.com/OXY2DEV/markview.nvim/commit/81c64a8cef523192aa084ccef469369f6ed8d7d1)), closes [#115](https://github.com/OXY2DEV/markview.nvim/issues/115)
* **renderer:** Added mode validator for hybrid_mode listeners ([c9fa106](https://github.com/OXY2DEV/markview.nvim/commit/c9fa1065098663c3bfe7e07656937c3d2f3dabea))
* **renderer:** Added option to disable top/bottom border & fixed a rendering error that occured when disabling "use_virt_lines" ([31d36e9](https://github.com/OXY2DEV/markview.nvim/commit/31d36e935fd962099fdacffe2629305e26eff8ed))
* **renderer:** Added support for language names in code blocks ([5db0e8e](https://github.com/OXY2DEV/markview.nvim/commit/5db0e8ea917d07ea1de6670cf256a4169c3d5601)), closes [#72](https://github.com/OXY2DEV/markview.nvim/issues/72)
* **renderer:** Added the filetype finding function to the code blocks renderer ([d69122d](https://github.com/OXY2DEV/markview.nvim/commit/d69122dbf3f340bd9f5dfbb55bef2f71ed65858d)), closes [#72](https://github.com/OXY2DEV/markview.nvim/issues/72)
* **renderer:** Fixed a big causing numbered lists to use virtual text ([6404094](https://github.com/OXY2DEV/markview.nvim/commit/6404094d692262bb446e2887822e2aa7d69f7efa))
* **renderer:** Fixed incorrect alignment of nested code blocks within lists ([738ddc0](https://github.com/OXY2DEV/markview.nvim/commit/738ddc0390449c0652f34b99a6cbe0699b2fcf58))
* **renderer:** Made icons optional ([6671dd4](https://github.com/OXY2DEV/markview.nvim/commit/6671dd45ea5eabbc11ba9c400b54991681e95464))
* **renderer:** Reworked hybrid_mode ([e29b7b5](https://github.com/OXY2DEV/markview.nvim/commit/e29b7b5ac6a9f238b7a3ff85042c91ba76edbda8))
* **renderer:** Table cells now respect the column count & the cell width ([a0d8a5d](https://github.com/OXY2DEV/markview.nvim/commit/a0d8a5db74107ffe91cb3cab6b3065b7baccb663)), closes [#75](https://github.com/OXY2DEV/markview.nvim/issues/75)

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
