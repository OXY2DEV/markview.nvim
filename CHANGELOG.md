# Changelog

## [28.1.0](https://github.com/OXY2DEV/markview.nvim/compare/v28.0.0...v28.1.0) (2026-02-22)


### Features

* Asciidoc support ([c81ce9e](https://github.com/OXY2DEV/markview.nvim/commit/c81ce9ed129387fc5fdec91abe9818a1b0e6fcac))
* **asciidoc_inline:** Added `#highlight#` support ([32c0ddd](https://github.com/OXY2DEV/markview.nvim/commit/32c0ddd390ed3111b2ee18f38d3fc416ab9915db))
* **asciidoc_inline:** Added `labeled uri` support ([b4a4eb2](https://github.com/OXY2DEV/markview.nvim/commit/b4a4eb2e8f34b375101f3337a64aadef298e6314))
* **asciidoc_inline:** Added `monospce`s support ([a324d09](https://github.com/OXY2DEV/markview.nvim/commit/a324d09c407232ed15c9b59e73293ae154efcdd4))
* **asciidoc_inline:** Added `uri macro` support ([f1f1167](https://github.com/OXY2DEV/markview.nvim/commit/f1f11678988fec1ba86122208bb9c2bf75a3fad2))
* **asciidoc_inline:** Added parser template ([75ae830](https://github.com/OXY2DEV/markview.nvim/commit/75ae830af19853de5dacdd84f440be711c9003e0))
* **asciidoc_inline:** Added support for unlabeled URIs ([0c463e3](https://github.com/OXY2DEV/markview.nvim/commit/0c463e307cedb27b7135f33db200d941a8d3d26c))
* **asciidoc:** Added `block quotes` ([9b576e9](https://github.com/OXY2DEV/markview.nvim/commit/9b576e92462caa5be93761093e4834c82bd19ff3)), closes [#455](https://github.com/OXY2DEV/markview.nvim/issues/455)
* **asciidoc:** Added `code blocks` ([86ce3fe](https://github.com/OXY2DEV/markview.nvim/commit/86ce3fe623fe54319a1f1d4ce6b861219c95b151)), closes [#455](https://github.com/OXY2DEV/markview.nvim/issues/455)
* **asciidoc:** Added `delimited blocks` & `admonition blocks` support ([ffb465f](https://github.com/OXY2DEV/markview.nvim/commit/ffb465f7b99135eb7676bd2edf53803acc97dcc6)), closes [#455](https://github.com/OXY2DEV/markview.nvim/issues/455)
* **asciidoc:** Added `document title` support ([966a713](https://github.com/OXY2DEV/markview.nvim/commit/966a713f3d28cb59f6cb8defa7b101561bac4a89))
* **asciidoc:** Added `section_title` support ([99f6641](https://github.com/OXY2DEV/markview.nvim/commit/99f66416f46db565c4061e3141102100c3315aa5))
* **asciidoc:** Added `TOC` support ([69226e4](https://github.com/OXY2DEV/markview.nvim/commit/69226e424188728e15c5504746f18bbdc20704a8))
* **asciidoc:** Added admonitions support ([8cc85d4](https://github.com/OXY2DEV/markview.nvim/commit/8cc85d445a31feeb8bb0d792726d1fba1b761bb0))
* **asciidoc:** Added checkboxes support ([40ac165](https://github.com/OXY2DEV/markview.nvim/commit/40ac165eda9c79f8821f0cf91cb06a04130eba2d))
* **asciidoc:** Added document attributes ([7da3aea](https://github.com/OXY2DEV/markview.nvim/commit/7da3aea514199505e13c83bbc3a84200c614cacb))
* **asciidoc:** Added horizontal rule support ([30da385](https://github.com/OXY2DEV/markview.nvim/commit/30da3855fc6c264e79a413936c50ebdf06f767e8))
* **asciidoc:** Added Image macro support ([d482fb5](https://github.com/OXY2DEV/markview.nvim/commit/d482fb5e2acd470604fa72da01ee5a2ff71724d4))
* **asciidoc:** Added keycodes support ([f245285](https://github.com/OXY2DEV/markview.nvim/commit/f2452854cac5fce5fb79f3b9a95f0f603fcc7182))
* **asciidoc:** Added Literal block support ([5f2cc46](https://github.com/OXY2DEV/markview.nvim/commit/5f2cc4681c7bfd1610d7e85c9db6e203db29a284))
* **asciidoc:** Added ordered & unordered list item support ([318d47e](https://github.com/OXY2DEV/markview.nvim/commit/318d47e02dbb8b50f2c0eb47ce0f7e782896d34b))
* **comment:** Added `bold` & `italic` support ([87d74af](https://github.com/OXY2DEV/markview.nvim/commit/87d74af3f0c0a811080fc5412d8b9c5526573700))
* **comment:** Added `code_block` support ([06fa1fc](https://github.com/OXY2DEV/markview.nvim/commit/06fa1fc145e4f3b252c3f75603f842ccc98bc36d))
* **comment:** Added `url`, `taglink` & `autolink` ([6da007d](https://github.com/OXY2DEV/markview.nvim/commit/6da007d6cffa72de7c10fe04ab05b0bfb35e4509))
* **comment:** Added compatibilty for legacy parser ([05a6d53](https://github.com/OXY2DEV/markview.nvim/commit/05a6d53d5a871d7e8ff835bafdf3d7faf5aa3426))
* **comment:** Added link labels for `autolinks` ([492f4e7](https://github.com/OXY2DEV/markview.nvim/commit/492f4e723744cbe05d8716fa6400f4e4988076f3))
* **comment:** Added option for rendering *fancy comments* ([f83c081](https://github.com/OXY2DEV/markview.nvim/commit/f83c081895c8fa06c162b431146781fc187bcc28))
* **comment:** Added task scopes support ([6c07f8f](https://github.com/OXY2DEV/markview.nvim/commit/6c07f8f01fe76c6a4da774e1212a23b7671ace3e))
* **config, comment, tasks:** Added more task type configs ([ab00aa4](https://github.com/OXY2DEV/markview.nvim/commit/ab00aa4fb1270e55ecc18039a062c2ccd6d02d48))
* **config, comment:** Added missing config options ([ab00aa4](https://github.com/OXY2DEV/markview.nvim/commit/ab00aa4fb1270e55ecc18039a062c2ccd6d02d48))
* **doctext:** Added `task` renderer ([46587f5](https://github.com/OXY2DEV/markview.nvim/commit/46587f58654933ea3f12d8ac1c289eee29287902))
* **doctext:** Added configuration for `doctext` ([9c4a9a4](https://github.com/OXY2DEV/markview.nvim/commit/9c4a9a4de1f488e2d5777dfd9dc8531d47f40e10))
* **doctext:** Added issue support ([46587f5](https://github.com/OXY2DEV/markview.nvim/commit/46587f58654933ea3f12d8ac1c289eee29287902))
* **doctext:** Added mention support ([46587f5](https://github.com/OXY2DEV/markview.nvim/commit/46587f58654933ea3f12d8ac1c289eee29287902))
* Fancy comments ([9935a98](https://github.com/OXY2DEV/markview.nvim/commit/9935a986432f0736319f14ed87a6fb10f78859a3))
* **parsers:** Added `doctext` parser ([cd202c2](https://github.com/OXY2DEV/markview.nvim/commit/cd202c27e61239af5b95d6a6b984f40f1d98340c))


### Bug Fixes

* **asciidoc, asciidoc_inline:** Added option maps ([5c5b4b7](https://github.com/OXY2DEV/markview.nvim/commit/5c5b4b7f8150d918251cc923026b1d0f5f8fdc0d))
* **asciidoc, checkboxes:** `scope_hl` is implemented ([50d672a](https://github.com/OXY2DEV/markview.nvim/commit/50d672a188d4a07ac00f6a155571160dcf6e3032))
* **asciidoc, list_items:** Item index is now correctly parsed ([508b6b9](https://github.com/OXY2DEV/markview.nvim/commit/508b6b969f74972cee181592004ddba2cf5f5a6b))
* **asciidoc:** Fixed incorrect type definitions ([6e22829](https://github.com/OXY2DEV/markview.nvim/commit/6e228298c72a3b5f813c342a0f171fe2ac8d4450))
* **asciidoc:** Typo fixes and corrected `hl` handling ([86e2643](https://github.com/OXY2DEV/markview.nvim/commit/86e2643106a29d71403f0fad6a93b1f18df510db))
* **asciidoc:** Updated base config ([afe02ad](https://github.com/OXY2DEV/markview.nvim/commit/afe02adb1bba682c0887bae9dfac309ac9d52d79))
* **config, condition:** Parity between `can_attach()` & `buf_handle()` ([d92f4d3](https://github.com/OXY2DEV/markview.nvim/commit/d92f4d3fdef5b1e80011dd42ef72a008d901b3ab))
* correct typo and function call in hybridToggle action ([18fc148](https://github.com/OXY2DEV/markview.nvim/commit/18fc148c83925919d94f3fc8e5c74f2d108b9b44))
* correct typo and function call in hybridToggle action ([9864ca2](https://github.com/OXY2DEV/markview.nvim/commit/9864ca29e146fc1d55ce2bae34f5c1b9034b3bb7))
* **doctext:** `@` in mentions are now hidden ([0d815a8](https://github.com/OXY2DEV/markview.nvim/commit/0d815a8c73d8da9aae19731a984ab84f12097953))
* **filetypes:** Proerly handle `nil` values ([c99341c](https://github.com/OXY2DEV/markview.nvim/commit/c99341c143a22579605e3dafeff2e821d1f75a44))
* **lazy:** Try attaching to buffers if lazy loaded ([633e627](https://github.com/OXY2DEV/markview.nvim/commit/633e627f82011dc888ea4444a98c98bd783951b0))
* no longer overriding blink-cmp per_filetype sources ([a185a64](https://github.com/OXY2DEV/markview.nvim/commit/a185a643e301d023f6364ffe60da41607ba82733))
* **parsers, asciidoc_inline:** Reduce unnecessary recursion when parsing ([c81472c](https://github.com/OXY2DEV/markview.nvim/commit/c81472c16e2ac93d14517d59b9da386adafd4a15))
* **renderer, asciidoc, tostring:** Fixed escape char matches ([766fda4](https://github.com/OXY2DEV/markview.nvim/commit/766fda4f9e87d2450b296d74bfe9aab89a3e4675))
* **renderer, typst, code_block:** Added wrap support ([5465846](https://github.com/OXY2DEV/markview.nvim/commit/5465846fcec3d5222369b0565b952b8d46fec9be)), closes [#470](https://github.com/OXY2DEV/markview.nvim/issues/470)
* **renderer, visual_text:** Visual text isn't applied if parser is ([8f20e21](https://github.com/OXY2DEV/markview.nvim/commit/8f20e21cfcf238927f47ded082cb83be02fe52e5)), closes [#455](https://github.com/OXY2DEV/markview.nvim/issues/455)
* **renderers, asciidoc_inline:** Fixed bug with icon not showing ([cead72e](https://github.com/OXY2DEV/markview.nvim/commit/cead72e29b26c2502e4d3074bec9c7ef977189d4))
* **renderers, asciidoc_inline:** Fixed conceal for `bold` & `italic`s ([97a024b](https://github.com/OXY2DEV/markview.nvim/commit/97a024bd37b8e0b13419b676971e9b7723d36be1))
* **renderers, asciidoc, document_titles:** Correctly handle conceal ([33e897d](https://github.com/OXY2DEV/markview.nvim/commit/33e897d8404b1fb97cb8aec3648a6bb36b7230be))
* **yaml:** Disable rendering of YAML in code blocks ([9e852c2](https://github.com/OXY2DEV/markview.nvim/commit/9e852c299351fc2110e763edc7fc899358ee112e)), closes [#455](https://github.com/OXY2DEV/markview.nvim/issues/455)

## [28.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v27.0.0...v28.0.0) (2025-12-23)


### ⚠ BREAKING CHANGES

* Updated health module
* Dropped backwards compatibility for versions lower than v25.0.0

### Features

* **hl:** Configurable blend color for dynamic highlight groups ([f6f930d](https://github.com/OXY2DEV/markview.nvim/commit/f6f930dda4059e08854e651e2716c09110307629)), closes [#428](https://github.com/OXY2DEV/markview.nvim/issues/428) [#172](https://github.com/OXY2DEV/markview.nvim/issues/172)
* **latex, symbols:** Added `\to` ([8e6a30b](https://github.com/OXY2DEV/markview.nvim/commit/8e6a30b728374eb244761a8027306f96c58eef8f)), closes [#440](https://github.com/OXY2DEV/markview.nvim/issues/440)
* **markdown_inline, code_span:** Added option to control when virtual text is used ([3d357f2](https://github.com/OXY2DEV/markview.nvim/commit/3d357f2742f20a23192c82df0842c61dbad29efa))
* **markdown_inline, code_span:** Multi backtick code span support ([2bfbe93](https://github.com/OXY2DEV/markview.nvim/commit/2bfbe93ee450fa8765db4739284f754f3bf13b6c)), closes [#451](https://github.com/OXY2DEV/markview.nvim/issues/451)
* **markdown, tables:** Allpw blank columns when 2 or more spaces are used ([f00ec33](https://github.com/OXY2DEV/markview.nvim/commit/f00ec3315ac9a55d10d197932cfcf51ec66be032)), closes [#450](https://github.com/OXY2DEV/markview.nvim/issues/450)
* **strict_render:** Strict renderer now takes a config ([7f92df1](https://github.com/OXY2DEV/markview.nvim/commit/7f92df17cc5fde1470733feae792f0cb12857761))


### Bug Fixes

* **actions:** `disable()` no longer sometimes disables the plugin globally ([7293a56](https://github.com/OXY2DEV/markview.nvim/commit/7293a56d4099c7d23b23cc5aaa572ffd821ba8bc))
* Add proper icon for typst files. ([7f9e78b](https://github.com/OXY2DEV/markview.nvim/commit/7f9e78b436c712033a5618df45d7806991b5e272))
* Fixed a bug with `disable()` ([efa9b0c](https://github.com/OXY2DEV/markview.nvim/commit/efa9b0c2808c5cf51199e2d6a19fba81408d6352)), closes [#431](https://github.com/OXY2DEV/markview.nvim/issues/431)
* **highlights:** Do not explicitly set background for `Palette<n>Sign` hls ([bf62f7d](https://github.com/OXY2DEV/markview.nvim/commit/bf62f7d173f4b42cd02794c6c5f5a8bd3047a58a)), closes [#452](https://github.com/OXY2DEV/markview.nvim/issues/452)
* **markdown_inline, inline_codes:** Added support for text wrap in mask ([80bcce9](https://github.com/OXY2DEV/markview.nvim/commit/80bcce95bf000468b7fe06724066aa4350cc842e))
* **markdown, code_blocks:** Using `tab` now disables `block` style ([00ab962](https://github.com/OXY2DEV/markview.nvim/commit/00ab962f0eb8e3cfe25dd4391158c1ec9aeb99f4))
* **markdown, heading, markdown_inline, code_span:** Fixed logic for ([2bfbe93](https://github.com/OXY2DEV/markview.nvim/commit/2bfbe93ee450fa8765db4739284f754f3bf13b6c))
* **markdown, setext_heading:** Icon alignment fix ([2af180a](https://github.com/OXY2DEV/markview.nvim/commit/2af180a226740bcc5e595d0632b72bd3ec6cb2b4))
* **markdown, table, wrap:** Fixed separator placemnent position ([86fcabc](https://github.com/OXY2DEV/markview.nvim/commit/86fcabc793e8aa361cb308e794cd0e1356fdc0e1)), closes [#442](https://github.com/OXY2DEV/markview.nvim/issues/442)
* **markdown:** Added edge case detection for table Lpeg parser ([1cc1312](https://github.com/OXY2DEV/markview.nvim/commit/1cc13125181724b7e720f7479635aaa4f16cce15)), closes [#439](https://github.com/OXY2DEV/markview.nvim/issues/439)
* prevent crash when set_query is called on non-markdown buffer ([3985e74](https://github.com/OXY2DEV/markview.nvim/commit/3985e748809aa7b0e7f03cf6c76937c58b67bc63))
* prevent crash when set_query is called on non-markdown buffer ([c3391ae](https://github.com/OXY2DEV/markview.nvim/commit/c3391aebaf09a165a4a84b487f4d4ab8b507851d))
* **queries:** Queries are now set during `BufEnter` ([af676ed](https://github.com/OXY2DEV/markview.nvim/commit/af676ed4bbf4824d6d6b0263e26773ce15fb7091))
* **wrap:** Do not override `breakindent` if wrap suppprt isn't used ([c2bd780](https://github.com/OXY2DEV/markview.nvim/commit/c2bd7805efb0d3ceaaa84e2df62d21892718cd93))
* **wrap:** Fixed wrapping issues with `signcolumn=auto` & default statuscolumn ([522bdd0](https://github.com/OXY2DEV/markview.nvim/commit/522bdd0cf2e0b7ff54e2a131950dadf7ffb71d71)), closes [#434](https://github.com/OXY2DEV/markview.nvim/issues/434)
* **wrap:** Indent no longer gets placed at end of line ([5529dc4](https://github.com/OXY2DEV/markview.nvim/commit/5529dc4af26bbf00bf4ddcac797f8116baf6571e))
* **wrap:** Indents are no longer added if there is not enough text after it ([8b2cf30](https://github.com/OXY2DEV/markview.nvim/commit/8b2cf308f55245ce3a1524957124ac75e4ded25c)), closes [#434](https://github.com/OXY2DEV/markview.nvim/issues/434)


### Performance Improvements

* **spec:** don't double eval func in `to_static` ([6d48f6a](https://github.com/OXY2DEV/markview.nvim/commit/6d48f6adbc4fdff5d3af4c1e771e4e56b24ee20e))
* **spec:** don't double eval func in `to_static` ([55b1df5](https://github.com/OXY2DEV/markview.nvim/commit/55b1df59bce0074873223531d040b9f489d34caf))


### Code Refactoring

* Dropped backwards compatibility for versions lower than v25.0.0 ([441114d](https://github.com/OXY2DEV/markview.nvim/commit/441114d6114371af3b689a9ef30ffd10e7349138))
* Updated health module ([91ff27f](https://github.com/OXY2DEV/markview.nvim/commit/91ff27f5357190e88d14f0adc0027257f5616241))

## [27.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v26.0.1...v27.0.0) (2025-11-02)


### ⚠ BREAKING CHANGES

* **commands:** Migrated `commands` to their own sub-module
* Moved `plugin/markview.lua` into separate sub-modules
* Removed deprecated `commands`

### Features

* **config, html:** Added support for `<kbd></kbd>` ([22c1c8e](https://github.com/OXY2DEV/markview.nvim/commit/22c1c8ef1422b00360273722ad305a747bd4369b)), closes [#402](https://github.com/OXY2DEV/markview.nvim/issues/402)
* **html:** Added more tag support ([77d07ca](https://github.com/OXY2DEV/markview.nvim/commit/77d07ca5669836fa3e43d308b2b33d7e613fc331))
* **latex, commands:** Allow LTeX commands to optionally have 0 args ([86857db](https://github.com/OXY2DEV/markview.nvim/commit/86857db3ef74b2b4af50aafd0c0ea5f50b43f2e2))
* **latex:** 0 arg commamds support added ([b3e7b53](https://github.com/OXY2DEV/markview.nvim/commit/b3e7b53f3bbf1f903899142e5b85dabf8b605e86))
* **links:** Added ability to switch to sections in another file ([a56331c](https://github.com/OXY2DEV/markview.nvim/commit/a56331cb95360208de7505b9ab09f9be8cd5ce91)), closes [#410](https://github.com/OXY2DEV/markview.nvim/issues/410)
* **links:** Added basic link parser ([a9f471c](https://github.com/OXY2DEV/markview.nvim/commit/a9f471cb926156c457db86b7cac0a043f04109a8)), closes [#410](https://github.com/OXY2DEV/markview.nvim/issues/410)
* **links:** Added Github styled heading link(section link) support ([a17a33a](https://github.com/OXY2DEV/markview.nvim/commit/a17a33a86fcfdcdc285444ce1db55afd99f33e4d)), closes [#410](https://github.com/OXY2DEV/markview.nvim/issues/410)
* **links:** Fragment links now update the `jumplist` ([79f1049](https://github.com/OXY2DEV/markview.nvim/commit/79f1049f2de5735c217406efd42e40041b2d9e19)), closes [#410](https://github.com/OXY2DEV/markview.nvim/issues/410)
* **markdown:** Added basic support indented code blocks ([3720ca2](https://github.com/OXY2DEV/markview.nvim/commit/3720ca20375f1aca4519df0863343d610bbcac57))
* **presets:** Added new heading presets ([6569360](https://github.com/OXY2DEV/markview.nvim/commit/6569360b4c888c4bdca7fbb4acc5aa5cb4f264c4))
* **renderer_markdown:** Added `org_indent` support for `setext_headings` ([18a6a87](https://github.com/OXY2DEV/markview.nvim/commit/18a6a87fe91b476141ae9c96b3a3404fcaf76e78)), closes [#409](https://github.com/OXY2DEV/markview.nvim/issues/409)
* **renderer_markdown:** Added custom text support for numbered list items ([c18fa7a](https://github.com/OXY2DEV/markview.nvim/commit/c18fa7af2cb42aee4b371af7daa5b25e0b33a0ab)), closes [#412](https://github.com/OXY2DEV/markview.nvim/issues/412)
* **renderer_markdown:** Added support for `shift_width` in ([18a6a87](https://github.com/OXY2DEV/markview.nvim/commit/18a6a87fe91b476141ae9c96b3a3404fcaf76e78))


### Bug Fixes

* **actions, splitview:** Splitview preview buffer is now correctly updated ([cba2ff7](https://github.com/OXY2DEV/markview.nvim/commit/cba2ff7ca63287fa415cbe25129ec79064fe008b))
* **actions:** Fixed filetype for splitview buffer ([0344b6a](https://github.com/OXY2DEV/markview.nvim/commit/0344b6a24771accb8ba40ef627b53a9d06e6875f))
* **actions:** Hybrid mode is now handled correctly ([c3be7ad](https://github.com/OXY2DEV/markview.nvim/commit/c3be7ad20526fd28e9e77f4fc97988723c051928))
* **actions:** Splitview source is now correctly removed ([a3c536e](https://github.com/OXY2DEV/markview.nvim/commit/a3c536e55999cbb6b423628366d19bee441798ef))
* **core:** Fixed how `clean()` works ([eb8c8a1](https://github.com/OXY2DEV/markview.nvim/commit/eb8c8a1fe4499b4fe0bdce30c926e60680ab2d28))
* **core:** Update queries when filw is changed outside of Neovim ([c93ea99](https://github.com/OXY2DEV/markview.nvim/commit/c93ea99d96b4bfda5b7c7d0dfca9c26edf6e78f0)), closes [#419](https://github.com/OXY2DEV/markview.nvim/issues/419)
* **filetypes:** Fixed an issue with internal icon provider ([b2a1a0a](https://github.com/OXY2DEV/markview.nvim/commit/b2a1a0abe36a9a82b974dedba2e4a45314919e27))
* Fixed incorrect `org_indent` amount ([2374bc2](https://github.com/OXY2DEV/markview.nvim/commit/2374bc2d92dc8ba63b9981410766493e66085042)), closes [#409](https://github.com/OXY2DEV/markview.nvim/issues/409)
* **gx, links:** `🧩` is removed from fragment links ([fd3320f](https://github.com/OXY2DEV/markview.nvim/commit/fd3320f483c325474202de8ec51223f886c6ae49))
* **highlights:** Added background to `MarkviewInlineCode` highlight group ([2438138](https://github.com/OXY2DEV/markview.nvim/commit/243813809e07a44beef34f900fec29fa36b9317f))
* **highlights:** Fixed highlight for `MarkviewCodeInfo` ([2ddad87](https://github.com/OXY2DEV/markview.nvim/commit/2ddad873796139c131e306f28534cc4f34416a77)), closes [#416](https://github.com/OXY2DEV/markview.nvim/issues/416)
* **hybrid_mode:** Fixed how `raw_previews` is parsed ([34787bc](https://github.com/OXY2DEV/markview.nvim/commit/34787bc913f2448aacf9739df479724e662f899d))
* **lazy:** Fixed an issue with lazy-loading ([de79a76](https://github.com/OXY2DEV/markview.nvim/commit/de79a7626d54d7785436105ef72f37ee8fe8fa16)), closes [#403](https://github.com/OXY2DEV/markview.nvim/issues/403)
* **lazy:** Fixed logic for detecting lazy-loading ([1c57e6a](https://github.com/OXY2DEV/markview.nvim/commit/1c57e6af9482e7fe839c7bdc2e6a06259dbc4c75))
* **links:** Fixed mismatch types ([4a460b3](https://github.com/OXY2DEV/markview.nvim/commit/4a460b31fa7014c055e9533dce150af594d75306)), closes [#410](https://github.com/OXY2DEV/markview.nvim/issues/410)
* **links:** Various improvements to link parsing ([a56331c](https://github.com/OXY2DEV/markview.nvim/commit/a56331cb95360208de7505b9ab09f9be8cd5ce91))
* **org_indent:** Fixed incorrect range issues with `setext_heading`s ([89405b5](https://github.com/OXY2DEV/markview.nvim/commit/89405b50375795202163400c4a04ad2fde81698d)), closes [#407](https://github.com/OXY2DEV/markview.nvim/issues/407)
* **org_indent:** Tweaked section range calculation for `setext_heading` ([a3c43a2](https://github.com/OXY2DEV/markview.nvim/commit/a3c43a2b8413313c24bb2ae603b715fee37b2efb)), closes [#407](https://github.com/OXY2DEV/markview.nvim/issues/407)
* **parswr_markdown:** Fixed a bug causing incorrect conceal for code block delimiters ([2f5d568](https://github.com/OXY2DEV/markview.nvim/commit/2f5d568937111968ea9d8aa9d77640979a84792d)), closes [#417](https://github.com/OXY2DEV/markview.nvim/issues/417)
* **renderer_markdown:** Fixed a bug with incorrect highlight range for `code_blocks` ([8c6d294](https://github.com/OXY2DEV/markview.nvim/commit/8c6d294d3d6a59f892c131d76f699b0696a25467)), closes [#413](https://github.com/OXY2DEV/markview.nvim/issues/413)
* **renderer_markdown:** Fixed highlight issues with tables ([6616796](https://github.com/OXY2DEV/markview.nvim/commit/6616796739c1a3ee002281b4980593158e81f30e)), closes [#407](https://github.com/OXY2DEV/markview.nvim/issues/407)
* **renderer_markdown:** Fixed incorrect shift amount & org_indent in renders ([7fb8978](https://github.com/OXY2DEV/markview.nvim/commit/7fb897845c88f61fda9ce014af916d2a55466d8b))
* **spec:** Fixed icon for anchor tags ([d8b1ba4](https://github.com/OXY2DEV/markview.nvim/commit/d8b1ba41c40d35727b279233a3d16a41ccd11c49))
* **splitview:** `list` & `winhl` are now disabled in `splitview` ([6cdbe74](https://github.com/OXY2DEV/markview.nvim/commit/6cdbe7455886520d9113753599052fec1c4548f8))
* **splitview:** Disabled `number` & `relativenumber` for splutview ([587005b](https://github.com/OXY2DEV/markview.nvim/commit/587005bb987f01467aa46f14c12911f81d23364e))
* **splitview:** Fixed an issue with queries not being applied to splitview window ([587005b](https://github.com/OXY2DEV/markview.nvim/commit/587005bb987f01467aa46f14c12911f81d23364e))
* **splitview:** Fixed incorrect text updating ([7acfc92](https://github.com/OXY2DEV/markview.nvim/commit/7acfc92e693601579207456eb89e30753b179e6d)), closes [#408](https://github.com/OXY2DEV/markview.nvim/issues/408)
* **state:** `enable()` now works correctly ([7e6b408](https://github.com/OXY2DEV/markview.nvim/commit/7e6b408fd3984aff0385c92b53499c25d47cc687))
* **state:** Fixed a bug causing stack overflow ([7c162d3](https://github.com/OXY2DEV/markview.nvim/commit/7c162d3374756b4f5986e76ce903732f2d665ceb))
* **wrap:** Fixed incorrect wrapping when called on non-current window ([2b04e70](https://github.com/OXY2DEV/markview.nvim/commit/2b04e707524c2a9eee17ba652c479610551e894a))


### Reverts

* **actions:** Reverted action name changes ([30f1e33](https://github.com/OXY2DEV/markview.nvim/commit/30f1e33e9f24510487ff27ecf6797bc360bfb623))


### Code Refactoring

* **commands:** Migrated `commands` to their own sub-module ([c3ce771](https://github.com/OXY2DEV/markview.nvim/commit/c3ce7719d7ec8c76a119bd05c01b2c4b1b4a6d65))
* Moved `plugin/markview.lua` into separate sub-modules ([1401a85](https://github.com/OXY2DEV/markview.nvim/commit/1401a85d28fe3eb516739b2a85b2a7eac603214d))
* Removed deprecated `commands` ([6d8c009](https://github.com/OXY2DEV/markview.nvim/commit/6d8c0098402b0db79a4879b7b56678db2cd7ad25))

## [26.0.1](https://github.com/OXY2DEV/markview.nvim/compare/v26.0.0...v26.0.1) (2025-09-30)


### Bug Fixes

* **parser_markdown:** Fixed an error with trailing wrap cleanup code ([7bdec07](https://github.com/OXY2DEV/markview.nvim/commit/7bdec07cb9a14b34edaee9776d92658b8773f4fa))
* **renderer_markdown:** Fixed a bug where trailing code block delimiters don't get hidden ([f8f4470](https://github.com/OXY2DEV/markview.nvim/commit/f8f44709af021ba24a50674bb9a66adbab26f98f))

## [26.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.11.0...v26.0.0) (2025-09-28)


### ⚠ BREAKING CHANGES

* **wrap:** Removed relaince on `screenpos` for wrap support
* **wrap:** Reworked how `wrap` support is implamented
* Calling `setup()` no longer re-apply highlights
* **config:** Separated config into multiple files
* Removed dependency for custom query files

### refacto

* **wrap:** Removed relaince on `screenpos` for wrap support ([01825b0](https://github.com/OXY2DEV/markview.nvim/commit/01825b0e3c1ed5fb40fcaf0d9ada42b0a8404f58))


### Features

* **parser_markdown:** Parsed list items now have nesting data ([24f5b38](https://github.com/OXY2DEV/markview.nvim/commit/24f5b3867947b49dbd41ec8d251119c268450d3f))
* **parser_markdown:** Parsed sections now have indentation ranges ([92c6168](https://github.com/OXY2DEV/markview.nvim/commit/92c6168c36796892f3952ebf1408fa706ab8f949))


### Bug Fixes

* **config:** Fixed an issue with `<a></a>` tags icon being cut off ([fd4bc72](https://github.com/OXY2DEV/markview.nvim/commit/fd4bc723276b2008c6f68758fae0dedabbec267c))
* **core:** Fixed issues with non-existing buffer missing state value ([82c21e3](https://github.com/OXY2DEV/markview.nvim/commit/82c21e3b3f982ae76107a787fb28383d76fffeab)), closes [#394](https://github.com/OXY2DEV/markview.nvim/issues/394)
* **parser_markdown:** Added missing proeprty for block quotes ([1ec84d4](https://github.com/OXY2DEV/markview.nvim/commit/1ec84d43e76e770aa37899ce1788646d6b3f620a))
* **parser_markdown:** Fixes indentation of trailing lines in list items ([3df4aea](https://github.com/OXY2DEV/markview.nvim/commit/3df4aea6a8ecdf6451a44325c8cf0d397e869a40)), closes [#399](https://github.com/OXY2DEV/markview.nvim/issues/399)
* **renderer_markdown:** Block quote borders now have correct `right_gravity` ([1276282](https://github.com/OXY2DEV/markview.nvim/commit/1276282cd01ed822be4603348fdb58227b8b3b87))


### Code Refactoring

* Calling `setup()` no longer re-apply highlights ([b895174](https://github.com/OXY2DEV/markview.nvim/commit/b895174117b00ce993242f0d0123c2b9f04abb6a))
* **config:** Separated config into multiple files ([b7aeff1](https://github.com/OXY2DEV/markview.nvim/commit/b7aeff113d16cb74067b7ba425a694ef3e3996d6))
* Removed dependency for custom query files ([b8cec24](https://github.com/OXY2DEV/markview.nvim/commit/b8cec240cd76d4d4c743b874b16222082c92970f)), closes [#332](https://github.com/OXY2DEV/markview.nvim/issues/332)
* **wrap:** Reworked how `wrap` support is implamented ([b5f90fe](https://github.com/OXY2DEV/markview.nvim/commit/b5f90fe92974d16a1d07e4617e7a74e21b4ed32d)), closes [#393](https://github.com/OXY2DEV/markview.nvim/issues/393)

## [25.11.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.10.0...v25.11.0) (2025-09-01)


### Features

* **parser_markdown:** Added heading level to parsed data ([b342ee9](https://github.com/OXY2DEV/markview.nvim/commit/b342ee9f2058a800636ab15cf0ecc09ce0b4d1d2)), closes [#384](https://github.com/OXY2DEV/markview.nvim/issues/384)
* **renderer_latex:** Added some supplementary symbols for `subscript` & `superscript` ([6e06451](https://github.com/OXY2DEV/markview.nvim/commit/6e06451f4952de0fb8d1454943405c51854121f8)), closes [#379](https://github.com/OXY2DEV/markview.nvim/issues/379)


### Bug Fixes

* **core:** Check buffee validity before running callbacks after closing `splitView` ([4e5f93e](https://github.com/OXY2DEV/markview.nvim/commit/4e5f93e054b1c3dce026731dfcea1e44b0941137)), closes [#388](https://github.com/OXY2DEV/markview.nvim/issues/388)
* **parsee_markdown:** Fixed a bug with how text was extracted from elements ([6d63416](https://github.com/OXY2DEV/markview.nvim/commit/6d63416c86ed1be16ad66a042ae7d2b15c53152e)), closes [#387](https://github.com/OXY2DEV/markview.nvim/issues/387)
* **parser_latex:** Added new symbols to the parser ([2f071fd](https://github.com/OXY2DEV/markview.nvim/commit/2f071fd428b2cabd3271b45f5b046db43b60c1da))
* **parser_markdown:** Fixed a bug with missing indent level ([3feaed6](https://github.com/OXY2DEV/markview.nvim/commit/3feaed690e5be223108a7f9727e3f962832e9c3b)), closes [#384](https://github.com/OXY2DEV/markview.nvim/issues/384)
* **renderer_latex:** Removed incorrect `epsilon` symbol for `subscript` ([ea7e9d6](https://github.com/OXY2DEV/markview.nvim/commit/ea7e9d6e8107d9226426fc9a34cce0413c22e8c2)), closes [#379](https://github.com/OXY2DEV/markview.nvim/issues/379)
* **renderer_markdown:** Fixed an issue with `org_indent` not handling indention correctly ([#389](https://github.com/OXY2DEV/markview.nvim/issues/389)) ([e6b0f5a](https://github.com/OXY2DEV/markview.nvim/commit/e6b0f5aee8105adab6077509c46459812db4cffa))

## [25.10.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.9.0...v25.10.0) (2025-08-04)


### Features

* **core:** Added fixes for RTP issues with `nvim-treesitter` ([a456da1](https://github.com/OXY2DEV/markview.nvim/commit/a456da1f1fd2bd9be522457ceab1974109306a2b)), closes [#363](https://github.com/OXY2DEV/markview.nvim/issues/363)
* **core:** ts compat ([a4d10e7](https://github.com/OXY2DEV/markview.nvim/commit/a4d10e7ddb07d35fefaf9c5f4b48413b3ad28113))


### Bug Fixes

* **parser_markdown:** Fixed an issue with markdown parser not recognizing single column tables ([fbfcd8e](https://github.com/OXY2DEV/markview.nvim/commit/fbfcd8ed6e3a1323a326cf3384cf110c57eab87f))
* **renderer_markdown:** Added `~text~` support ([5bdb206](https://github.com/OXY2DEV/markview.nvim/commit/5bdb20619e42836a5e9087ff392b0dbcc95ed3f9)), closes [#378](https://github.com/OXY2DEV/markview.nvim/issues/378)
* **renderer_markdown:** Fixed a bug where calloits with no icon's would fail to render ([48180da](https://github.com/OXY2DEV/markview.nvim/commit/48180dae71e52965a7605809548c94e3bec61180)), closes [#367](https://github.com/OXY2DEV/markview.nvim/issues/367)

## [25.9.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.8.0...v25.9.0) (2025-06-11)


### Features

* Added supppet for using custom config in `render()` calls ([4956124](https://github.com/OXY2DEV/markview.nvim/commit/4956124ff15026437f1170d861fdbd1bdb1ae479)), closes [#353](https://github.com/OXY2DEV/markview.nvim/issues/353)
* **experimental:** Added option to prevent `org_ondent`'s from being hidden ([c00870e](https://github.com/OXY2DEV/markview.nvim/commit/c00870e544f81a0eecd89c1144cdf77458cf1f97)), closes [#360](https://github.com/OXY2DEV/markview.nvim/issues/360)


### Bug Fixes

* **entities:** Fixed an issuw with the checker function returning `nil` ([ffa848c](https://github.com/OXY2DEV/markview.nvim/commit/ffa848c6ca2f5097ef2bfb55733dae80add8552e))
* Fixed an issue with attaching to buffers that get deleted quickly ([5e9c1fc](https://github.com/OXY2DEV/markview.nvim/commit/5e9c1fca74eb0244beed625da813bb90293a0e40)), closes [#356](https://github.com/OXY2DEV/markview.nvim/issues/356)
* **markdown:** Fixed a bug with callouts not inheriting option values from `default` ([c0f67d4](https://github.com/OXY2DEV/markview.nvim/commit/c0f67d4283ffdb2fada4e0782d3906bcdeb94732))
* **markdown:** Fixed a bug with list item indent size type mismatch ([5cec366](https://github.com/OXY2DEV/markview.nvim/commit/5cec366a44b10b3ae507fb63d640d97d3aa08ac5))
* **renderer_markdown:** apply `scope_hl` when concealing is disabled ([cbb5223](https://github.com/OXY2DEV/markview.nvim/commit/cbb52237a22b98eb85e7de6a6e1fbb44d812310a))
* **renderer_markdown:** apply `scope_hl` when concealing is disabled ([29608fc](https://github.com/OXY2DEV/markview.nvim/commit/29608fc5cdf8558e29c4149691384280f429dcd4))
* **renderers:** Removed the need for a visible window in renderers ([a225dcb](https://github.com/OXY2DEV/markview.nvim/commit/a225dcb37acb569d37b6b62f5a568ce6a194ebd7))
* **sepc:** Added missing deprecation alert ([a803117](https://github.com/OXY2DEV/markview.nvim/commit/a803117f272cc47733b67ebbaf1acb91095da276))
* **typst:** Fixed a bug with list item indent size type mismatch ([2371e09](https://github.com/OXY2DEV/markview.nvim/commit/2371e096f9062c9598a1da10d0c7cf33e014e717))
* **utils:** Added support for `main` branch of nvim-treesitter ([16e4786](https://github.com/OXY2DEV/markview.nvim/commit/16e478603813e8913847a6f43f00d222445deae9)), closes [#357](https://github.com/OXY2DEV/markview.nvim/issues/357)
* **utils:** calling `buf_getwin` with 0 no longer returns `{}` ([bd7bd8f](https://github.com/OXY2DEV/markview.nvim/commit/bd7bd8f88b9b325fea3bd63db7b2f6cd7cfe513b))

## [25.8.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.7.0...v25.8.0) (2025-05-27)


### Features

* **gx:** Added option to disable `gx` mapping ([a9584cd](https://github.com/OXY2DEV/markview.nvim/commit/a9584cd5e87341c78162dfafeb1ac03f13d1f910)), closes [#346](https://github.com/OXY2DEV/markview.nvim/issues/346)
* **markdown:** Added option to make table parsing strict ([68c9603](https://github.com/OXY2DEV/markview.nvim/commit/68c9603b6f88fd962444f8579024418fe5e170f1)), closes [#349](https://github.com/OXY2DEV/markview.nvim/issues/349)
* **presets:** Added a preset for regular font users ([b88d735](https://github.com/OXY2DEV/markview.nvim/commit/b88d735155123d7b756f6521488551dafb9d8ba7)), closes [#350](https://github.com/OXY2DEV/markview.nvim/issues/350)


### Bug Fixes

* **blink:** Updated condition for blink.cmp source ([e966d1f](https://github.com/OXY2DEV/markview.nvim/commit/e966d1f7e230fceba6f793e27c6ac491ebc3d4cb))
* **cmp, blink:** Fixed an issue with completion sources not loading ([183c0ed](https://github.com/OXY2DEV/markview.nvim/commit/183c0ede469be11a88a26094754a0bf596a140e9)), closes [#351](https://github.com/OXY2DEV/markview.nvim/issues/351)
* **cmp:** Updated condition for nvim-cmp source ([e966d1f](https://github.com/OXY2DEV/markview.nvim/commit/e966d1f7e230fceba6f793e27c6ac491ebc3d4cb))
* **core:** Minor load time improvements ([91e9a51](https://github.com/OXY2DEV/markview.nvim/commit/91e9a511a4693cdb263f9fea57a16bfc0bbf1465))
* **core:** Reduced initial load time of parsers & renderers ([caa689a](https://github.com/OXY2DEV/markview.nvim/commit/caa689a1defabe56752f5d1dcea35a2c4eb97c0f))
* **filetypes:** Added support for `shell` filetype ([165121d](https://github.com/OXY2DEV/markview.nvim/commit/165121d0ec0ba8d3b68576eedb97c1dbc4f2301a))
* **hl:** Colorscheme highlight groups are now respected: ([23f8bda](https://github.com/OXY2DEV/markview.nvim/commit/23f8bda5a172287c3423a3ffe7640efefa52a48b))
* **hl:** Fixed how highlight group definition is checked ([cd47dc5](https://github.com/OXY2DEV/markview.nvim/commit/cd47dc5de88de0d50ce5eb8f30a84719d792c4c4))
* **icons:** Fixed option to disable icons ([1aa42c9](https://github.com/OXY2DEV/markview.nvim/commit/1aa42c981d305b4379e44eee00a78ff737858144)), closes [#350](https://github.com/OXY2DEV/markview.nvim/issues/350)
* **list_items:** Fixed incorrect character for list item markers ([2089a0f](https://github.com/OXY2DEV/markview.nvim/commit/2089a0f08dd3f83eb5f348c0080d70a6b87c7b98))
* **markdown:** Fixed variable name for table rows ([8bac6e9](https://github.com/OXY2DEV/markview.nvim/commit/8bac6e9463360450edf34f1a45e146ebca39e723))
* **renderer:** Fixed a bug with renderers not working ([f0a6f99](https://github.com/OXY2DEV/markview.nvim/commit/f0a6f99b2c979a3394ea5d31eb41ba5dbabe0516))
* **spec:** Minor load time improvement when calling `setup()` ([11e2cc3](https://github.com/OXY2DEV/markview.nvim/commit/11e2cc3ee127557f84ba7f21ff53849d0e2587ab))
* **ts_directive:** Tree-sitter directive is no longer lazy loaded ([03687b5](https://github.com/OXY2DEV/markview.nvim/commit/03687b5f707aca81d21e9f20e24557d55f6930be)), closes [#347](https://github.com/OXY2DEV/markview.nvim/issues/347)

## [25.7.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.6.0...v25.7.0) (2025-05-07)


### Features

* **core:** Added ability to toggle linewise hybrid mode ([4c880d2](https://github.com/OXY2DEV/markview.nvim/commit/4c880d2afaca8df7f7070b0143b5854bfc049dbe)), closes [#330](https://github.com/OXY2DEV/markview.nvim/issues/330)
* **latex:** Added `\mathrm{}` to latex fonts ([0f27afe](https://github.com/OXY2DEV/markview.nvim/commit/0f27afe779243e7ef01eb13cd570fdfe61644371)), closes [#341](https://github.com/OXY2DEV/markview.nvim/issues/341)


### Bug Fixes

* **config:** Fixed a bug with concealcursor beinh not set when preview is disabled ([eed5410](https://github.com/OXY2DEV/markview.nvim/commit/eed5410b17ad927b092dcc2579c40acdb655a41d))
* **core:** Fixed a bug with preview being shown after runnibg `Disable` ([2b810d7](https://github.com/OXY2DEV/markview.nvim/commit/2b810d72e1867739a1d617e6e244718d8d3a06f2))
* **link:** Allow users to change preference for opening text files ([7953828](https://github.com/OXY2DEV/markview.nvim/commit/795382867430559f4b776ebf378ca632965f23ff)), closes [#328](https://github.com/OXY2DEV/markview.nvim/issues/328)
* **renderer_markdown:** List item padding's `start_col` no longer exceeds line length ([40a7356](https://github.com/OXY2DEV/markview.nvim/commit/40a7356a44f20ba15138c1d7bcd1d9493fbf1d20))
* **renderer_markdown:** Shift width & indent size of list items now fallback to 1 when the function calculation fails ([180c67b](https://github.com/OXY2DEV/markview.nvim/commit/180c67ba92afe31600b2e4da2c98be078c740626))
* **renderer_markdown:** Signs for ATX heading now pass through `tostring()` first ([ad10211](https://github.com/OXY2DEV/markview.nvim/commit/ad10211a503c515d2da18946e71100f29bc074f6)), closes [#323](https://github.com/OXY2DEV/markview.nvim/issues/323)
* **renderer_markdown:** Turn non-number `indent_size` to 1 ([59d3baa](https://github.com/OXY2DEV/markview.nvim/commit/59d3baaac5b77aa3939f5a00acd335183e45930d)), closes [#323](https://github.com/OXY2DEV/markview.nvim/issues/323)

## [25.6.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.5.4...v25.6.0) (2025-03-28)


### Features

* Added &lt;pre&gt; to supported HTML tag list ([0d67884](https://github.com/OXY2DEV/markview.nvim/commit/0d6788416f8d935f6d6cba4a8dbdd5308cca3e7f)), closes [#323](https://github.com/OXY2DEV/markview.nvim/issues/323)
* **core:** Added &lt;a&gt; support to supported HTML container elements ([6499c7f](https://github.com/OXY2DEV/markview.nvim/commit/6499c7f7bab3e4a7cddf570c6abedcb41abc2eb3)), closes [#323](https://github.com/OXY2DEV/markview.nvim/issues/323)

## [25.5.4](https://github.com/OXY2DEV/markview.nvim/compare/v25.5.3...v25.5.4) (2025-03-23)


### Bug Fixes

* **blink:** Attempt to get dynamic source list for blink.cmp ([e4c47d2](https://github.com/OXY2DEV/markview.nvim/commit/e4c47d28dbccf2a56db8293df3e6e7fe6063fb84)), closes [#317](https://github.com/OXY2DEV/markview.nvim/issues/317)
* **cmp, blink:** Non-existing peview no longer causes error with completion ([2192327](https://github.com/OXY2DEV/markview.nvim/commit/2192327840a4da1b4bd22495e02dbd4f12af9413)), closes [#320](https://github.com/OXY2DEV/markview.nvim/issues/320)
* Markview no longer overwrites user source list for blink.cmp ([351366e](https://github.com/OXY2DEV/markview.nvim/commit/351366e7d2794456465dc6c48342177114ef15c0)), closes [#317](https://github.com/OXY2DEV/markview.nvim/issues/317)

## [25.5.3](https://github.com/OXY2DEV/markview.nvim/compare/v25.5.2...v25.5.3) (2025-03-18)


### Bug Fixes

* **blink:** Added support for both version of source provider ([f4c55fa](https://github.com/OXY2DEV/markview.nvim/commit/f4c55fa2720025e17cdf11fbc557216de64e2517)), closes [#315](https://github.com/OXY2DEV/markview.nvim/issues/315)

## [25.5.2](https://github.com/OXY2DEV/markview.nvim/compare/v25.5.1...v25.5.2) (2025-03-18)


### Bug Fixes

* **blink:** use add_source_provider due to deprecation ([7ebb1d2](https://github.com/OXY2DEV/markview.nvim/commit/7ebb1d2fe489f32ff0d347e0868407c504ffe8e0))
* **blink:** use add_source_provider due to deprecation ([382dd40](https://github.com/OXY2DEV/markview.nvim/commit/382dd401861b8604043427dfe44f343c56288dd4))

## [25.5.1](https://github.com/OXY2DEV/markview.nvim/compare/v25.5.0...v25.5.1) (2025-03-17)


### Bug Fixes

* **blink:** Switched to blink's API function for registering source ([725a271](https://github.com/OXY2DEV/markview.nvim/commit/725a271c96ecffb7fff606d4edf3b68cbe64e5b5)), closes [#310](https://github.com/OXY2DEV/markview.nvim/issues/310)
* **parser_markdown:** Empty lines now also receive indentation insidr of lists ([d3daa83](https://github.com/OXY2DEV/markview.nvim/commit/d3daa83ce97240f798d055525bbedc08f6fd1545)), closes [#311](https://github.com/OXY2DEV/markview.nvim/issues/311)
* **parser_markdown:** List tolerance now resets on non-empty lines ([d3daa83](https://github.com/OXY2DEV/markview.nvim/commit/d3daa83ce97240f798d055525bbedc08f6fd1545))

## [25.5.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.4.0...v25.5.0) (2025-03-14)


### Features

* LPeg parser for table rows ([9a135dd](https://github.com/OXY2DEV/markview.nvim/commit/9a135ddc29d3659a4df765dcc379df1a16672a11)), closes [#308](https://github.com/OXY2DEV/markview.nvim/issues/308)


### Bug Fixes

* **blink:** Fixed issues with loading completion source for blink.cmp ([17a93b3](https://github.com/OXY2DEV/markview.nvim/commit/17a93b32b688f1f5bf9328692ba0e6b2f06659d3)), closes [#310](https://github.com/OXY2DEV/markview.nvim/issues/310)

## [25.4.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.3.3...v25.4.0) (2025-03-11)


### Features

* **blink:** Added blink.cmp completion source ([929b5ba](https://github.com/OXY2DEV/markview.nvim/commit/929b5bad69e10775d3d1e65a8f259a923965e287)), closes [#200](https://github.com/OXY2DEV/markview.nvim/issues/200)
* **latex:** Added `\vec{}` support ([6c92a64](https://github.com/OXY2DEV/markview.nvim/commit/6c92a6455e97c954a4a419265a032fedd69846f6))

## [25.3.3](https://github.com/OXY2DEV/markview.nvim/compare/v25.3.2...v25.3.3) (2025-03-05)


### Bug Fixes

* Config evaluator no longer evaluates final function value using `args` ([ac31c1d](https://github.com/OXY2DEV/markview.nvim/commit/ac31c1dd7a5ba3bea6f9baf668c14ca80e4f6b9e)), closes [#272](https://github.com/OXY2DEV/markview.nvim/issues/272)

## [25.3.2](https://github.com/OXY2DEV/markview.nvim/compare/v25.3.1...v25.3.2) (2025-03-04)


### Bug Fixes

* **spec:** Broken function values now get replaced with `nil` ([213461f](https://github.com/OXY2DEV/markview.nvim/commit/213461f03905536bd340fa8831f102c9ec6fc606))

## [25.3.1](https://github.com/OXY2DEV/markview.nvim/compare/v25.3.0...v25.3.1) (2025-02-14)


### Bug Fixes

* **config:** Fixed link configuration order ([04c9082](https://github.com/OXY2DEV/markview.nvim/commit/04c908218fb01e771526893fdd3da8db51922ff5))
* **renderer_latex:** Added option to disable the default font in LaTeX ([f71aebe](https://github.com/OXY2DEV/markview.nvim/commit/f71aebe4031ce979e883442c11d91247890bb24e)), closes [#288](https://github.com/OXY2DEV/markview.nvim/issues/288)

## [25.3.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.2.0...v25.3.0) (2025-02-14)


### Features

* Markview now listens to BifWinEnter & OptionSet autocmds ([c7e70ab](https://github.com/OXY2DEV/markview.nvim/commit/c7e70ab2fd4e091801ed938b4838e27b3dde763c)), closes [#287](https://github.com/OXY2DEV/markview.nvim/issues/287)


### Bug Fixes

* **highlights:** Prefer newer tree-sitter highlights for creating colors ([c095a7c](https://github.com/OXY2DEV/markview.nvim/commit/c095a7c7c6343863fb3046781e295103e3e081ab))

## [25.2.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.1.2...v25.2.0) (2025-02-08)


### Features

* **renderer_markdown:** Dynamic `indent_size` & `shift_width` support for list items ([07a6688](https://github.com/OXY2DEV/markview.nvim/commit/07a668805e96b0975e6d5b0b50fd1d7b54e74417)), closes [#283](https://github.com/OXY2DEV/markview.nvim/issues/283)


### Bug Fixes

* **config:** List items `indent_size` now respects 'shiftwidth' ([93d3648](https://github.com/OXY2DEV/markview.nvim/commit/93d3648e0e293f8a0cb0704f2c9650384a9cde8a)), closes [#283](https://github.com/OXY2DEV/markview.nvim/issues/283)

## [25.1.2](https://github.com/OXY2DEV/markview.nvim/compare/v25.1.1...v25.1.2) (2025-02-06)


### Bug Fixes

* **core:** Fixed a bug with decoration overlapping ([a39d03f](https://github.com/OXY2DEV/markview.nvim/commit/a39d03f8445971c4a250396a44b23fa9c6fd8921))
* **icons:** Fixed an issue with incorrect string being used for icon fetching ([25d987a](https://github.com/OXY2DEV/markview.nvim/commit/25d987a58fd0ca3bef45473d7d656eba5bc83723)), closes [#282](https://github.com/OXY2DEV/markview.nvim/issues/282)

## [25.1.1](https://github.com/OXY2DEV/markview.nvim/compare/v25.1.0...v25.1.1) (2025-02-01)


### Bug Fixes

* **parser-markdown:** Fixed incorrect start column of code blocks with manual indentations ([85926af](https://github.com/OXY2DEV/markview.nvim/commit/85926af964f399e479ba175bef9976bf35442945))
* **treesitter:** Added directive check before adding new directive ([89f397d](https://github.com/OXY2DEV/markview.nvim/commit/89f397d0f4a2276c08a24b040a7f745cb4d3b504)), closes [#277](https://github.com/OXY2DEV/markview.nvim/issues/277)
* **typos:** Possibly all typos in plugin ([ca35213](https://github.com/OXY2DEV/markview.nvim/commit/ca35213f90a421869c865604484556f38f29b391))
* **typo:** the compatability should be the same ([2f1e438](https://github.com/OXY2DEV/markview.nvim/commit/2f1e438b09a1968a30c760692b846f20bf8d0e75))
* **typo:** the compatability should be the same ([2f1e438](https://github.com/OXY2DEV/markview.nvim/commit/2f1e438b09a1968a30c760692b846f20bf8d0e75))
* **typo:** weird ([d9804d8](https://github.com/OXY2DEV/markview.nvim/commit/d9804d8d4144d64d7923efcf9519be43f294af0c))

## [25.1.0](https://github.com/OXY2DEV/markview.nvim/compare/v25.0.3...v25.1.0) (2025-01-30)


### Features

* Added option to disable faking characters of subscript/supersc in Typst ([2975f6e](https://github.com/OXY2DEV/markview.nvim/commit/2975f6ea5e9a7653413d7258d8040d9ee68d1ddc)), closes [#271](https://github.com/OXY2DEV/markview.nvim/issues/271)
* Added option to disable faking preview of subscript/superscript in LaTeX ([c382be1](https://github.com/OXY2DEV/markview.nvim/commit/c382be12f166ed6bee8fe9fe6d4a41d1596af5c1)), closes [#271](https://github.com/OXY2DEV/markview.nvim/issues/271)


### Bug Fixes

* Buffer attach, enable state & preview modes are no longer checked for splitview ([81b40bd](https://github.com/OXY2DEV/markview.nvim/commit/81b40bd8c8c9e239bd14f7dace29f64fe20cbb98)), closes [#264](https://github.com/OXY2DEV/markview.nvim/issues/264)
* **presets:** Fix icon highlight for marker preset ([399fcce](https://github.com/OXY2DEV/markview.nvim/commit/399fccede8dcee89b5c84ef4a0670fe3dbb1cd32))
* **renderer_markdown:** Indentation concealing no longer breaks when `add_padding = false` ([aeb5b4e](https://github.com/OXY2DEV/markview.nvim/commit/aeb5b4e3eca3388e389cbd89d05045a5c4bcfda4)), closes [#267](https://github.com/OXY2DEV/markview.nvim/issues/267)

## [25.0.3](https://github.com/OXY2DEV/markview.nvim/compare/v25.0.2...v25.0.3) (2025-01-26)


### Bug Fixes

* **devicons:** properly fetch devicons by filetype ([1a60203](https://github.com/OXY2DEV/markview.nvim/commit/1a602031fa0549b1e0c0dba4f116187ea1313005))
* Visual text concealing is now done via `string.rep()` instead of `string.gsub()` ([d91c277](https://github.com/OXY2DEV/markview.nvim/commit/d91c277e55df98fe99bebf88e6ebf2cafc2bfebb)), closes [#260](https://github.com/OXY2DEV/markview.nvim/issues/260)

## [25.0.2](https://github.com/OXY2DEV/markview.nvim/compare/v25.0.1...v25.0.2) (2025-01-25)


### Bug Fixes

* Fixed an issue caused by `enable = false` when getting options from `preview` ([79539be](https://github.com/OXY2DEV/markview.nvim/commit/79539bec86a904855c13d0aee2776f372cbf7be7))

## [25.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v24.0.0...v25.0.0) (2025-01-25)


### ⚠ BREAKING CHANGES

* **spec:** Complete redesign of the configuration table
* **spec:** Dynamic configuration support
* **extras:** Completely changed how extra modules are used via
* **v25:** New version release
* **v25:** New version release

### Features

* Added a command to open link under cursor ([4ef3e11](https://github.com/OXY2DEV/markview.nvim/commit/4ef3e11292fdd4191e02ab865de2738d5fbeeba9)), closes [#173](https://github.com/OXY2DEV/markview.nvim/issues/173)
* **core:** Added typst support ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))
* **renderer_markdown:** Added diff support to code blocks ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))
* **spec:** Added pattern based config support for various items ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))
* **spec:** Dynamic configuration support ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))
* **v25:** New version release ([b7fca7a](https://github.com/OXY2DEV/markview.nvim/commit/b7fca7aee35108bf186260684479aa8c6bb921cf))
* **v25:** New version release ([b88a396](https://github.com/OXY2DEV/markview.nvim/commit/b88a3968337afe58dc6806dc19ba6a6b4618f12a))


### Bug Fixes

* **code-blocks:** Fixes multiple language parsing cases (tilde, spaces before/after, directives...) ([b7521d4](https://github.com/OXY2DEV/markview.nvim/commit/b7521d444d33517bbcbe033b183f3324f57dcd18)), closes [#234](https://github.com/OXY2DEV/markview.nvim/issues/234)
* **editor:** fixes editor for all fences format ([534dfc8](https://github.com/OXY2DEV/markview.nvim/commit/534dfc8d2beee518a3be7725dd6f7bd799cf64a4))
* Fixed callouts rendering ([493c054](https://github.com/OXY2DEV/markview.nvim/commit/493c054c6463156f1c584cffe006b2fc9ed2d34c))
* Fixed gx keymap rhs ([67b69cd](https://github.com/OXY2DEV/markview.nvim/commit/67b69cdaf9055bebac3682a070d7e5c8eecba29c))
* Fixed logic for detecting neovim version ([42b57e8](https://github.com/OXY2DEV/markview.nvim/commit/42b57e8f9a0fa69f1b2937342cdd27921346c990))
* Fixed merging of highlight groups ([b474374](https://github.com/OXY2DEV/markview.nvim/commit/b474374ba1186f8028e06b16c195b823cff492ee)), closes [#172](https://github.com/OXY2DEV/markview.nvim/issues/172)
* Fixed merging of highlight groups ([c29cf91](https://github.com/OXY2DEV/markview.nvim/commit/c29cf91e48979c12a8c1ac1e13d064720ee251d9)), closes [#172](https://github.com/OXY2DEV/markview.nvim/issues/172)
* Updated test ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))
* Various QOL fixes ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))


### Code Refactoring

* **extras:** Completely changed how extra modules are used via ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))
* **spec:** Complete redesign of the configuration table ([06f4c87](https://github.com/OXY2DEV/markview.nvim/commit/06f4c87e5499c5f192aa01a3a2bfa3bfbd4acdec))

## [24.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v23.1.0...v24.0.0) (2024-10-05)


### ⚠ BREAKING CHANGES

* **renderer:** Added more symbol definitions
* Added ability to detach/attach to a buffer
* name_hl for code blocks has been renamed to language_hl
* **highlights:** Fixed highlight groups for the plugin

### Features

* Ability to disable hybrid modes behavior when inside specific nodes ([7b913f9](https://github.com/OXY2DEV/markview.nvim/commit/7b913f9accb3739effdf2982789090cc570b9ec8)), closes [#154](https://github.com/OXY2DEV/markview.nvim/issues/154)
* Added a callback for split_view open ([6d4863c](https://github.com/OXY2DEV/markview.nvim/commit/6d4863c8575975e99b10c2950e06aebcdaf12ab2))
* Added a internal icon provider ([9923633](https://github.com/OXY2DEV/markview.nvim/commit/9923633fb6d029f3678311eff65c502a29e366cb))
* Added a simple code block creator and editor ([2d61f07](https://github.com/OXY2DEV/markview.nvim/commit/2d61f07d19fbf05e4247d5c974e9be0839c57657))
* Added ability to detach/attach to a buffer ([fd7fd02](https://github.com/OXY2DEV/markview.nvim/commit/fd7fd0213e3667b514b79ea18da89e86ec75734a))
* Added basic operator support ([e5fcd6a](https://github.com/OXY2DEV/markview.nvim/commit/e5fcd6a92e90ef0d22100a25c14b9877d475983b))
* Added option for setting maximum file length for rendering the entire file ([569fec1](https://github.com/OXY2DEV/markview.nvim/commit/569fec13ef831772bf898395b684c10f4a037e4d))
* **extras:** Added 2 new extra modules ([b2b2472](https://github.com/OXY2DEV/markview.nvim/commit/b2b2472cdf95139263ddcdfa6c9db789ad7a1f30))
* LaTeX parser now recognizes font commands ([fbe547c](https://github.com/OXY2DEV/markview.nvim/commit/fbe547c8ff90df2dd2040315a41e30ed5f32e7b4))
* New preset `minimal` for checkboxes ([7f675f8](https://github.com/OXY2DEV/markview.nvim/commit/7f675f891680a01fdf8d93ac72448f6aeef17d02))
* **parser:** Added support for footnotes ([1bd55e2](https://github.com/OXY2DEV/markview.nvim/commit/1bd55e21bc2def1c67bbcd94813fd4807b5d4fa5))
* **parser:** Internal link(obsidian) support ([837967f](https://github.com/OXY2DEV/markview.nvim/commit/837967f7465dcae4d30cfeda9157ed279d4b8927)), closes [#157](https://github.com/OXY2DEV/markview.nvim/issues/157)
* **renderer:** Added more symbol definitions ([963389b](https://github.com/OXY2DEV/markview.nvim/commit/963389bddf896584324a12a6f3c4d87250289131))
* **renderer:** More superscript characters for latex ([1bd55e2](https://github.com/OXY2DEV/markview.nvim/commit/1bd55e21bc2def1c67bbcd94813fd4807b5d4fa5))


### Bug Fixes

* `language` code block style has been renamed to `block` ([060a94b](https://github.com/OXY2DEV/markview.nvim/commit/060a94ba8d4d08660a40ed7ae94635c6fd410927))
* Added a checkhealth module ([b2d46d9](https://github.com/OXY2DEV/markview.nvim/commit/b2d46d945ae918978615cd07d4eb2147ef872fa7))
* Added a missing symbol to the LaTeX symbols table ([6d4863c](https://github.com/OXY2DEV/markview.nvim/commit/6d4863c8575975e99b10c2950e06aebcdaf12ab2))
* Added footnote configuration table to the default config ([d3d23cc](https://github.com/OXY2DEV/markview.nvim/commit/d3d23cc4a955a2b5bf8ee0976322868f808d06e4))
* Added highlight group for internal icons ([9230cda](https://github.com/OXY2DEV/markview.nvim/commit/9230cda6e45ecb2a741338b0fe81ffca9f06b208))
* Added highlight groups for the code block editor ([6cf12cd](https://github.com/OXY2DEV/markview.nvim/commit/6cf12cdf65aad8adc4f8d6e3c41c5b4634a26d38))
* Added missing `hybridDisable` & `hybridEnable` commands ([73b86f5](https://github.com/OXY2DEV/markview.nvim/commit/73b86f562e43b268a3f4ac4b6a21bddc63c928e2))
* Added missing overwrite option to treesitter injections ([89b65c3](https://github.com/OXY2DEV/markview.nvim/commit/89b65c35511a9039ddd326b8002f4bf739a14b99))
* Added new highlight groups ([7d2d763](https://github.com/OXY2DEV/markview.nvim/commit/7d2d763b1bd14fbbbe4ebb984cfa53d417c1c59f))
* Added support for \text{} & \set{} ([300e1fe](https://github.com/OXY2DEV/markview.nvim/commit/300e1fe3c7401d64337f28a8f64e2ffddc05ea0d)), closes [#162](https://github.com/OXY2DEV/markview.nvim/issues/162)
* Added the ability to overwrite injected queries ([4c41c66](https://github.com/OXY2DEV/markview.nvim/commit/4c41c668c12e1fe272123ed253c1e25a35474526))
* Adds the missing sign, sign_hl options for github style setext headings ([05dbce9](https://github.com/OXY2DEV/markview.nvim/commit/05dbce99c44f2f1a95ae2cbd3a74fbf6b8108f44))
* Better case handling for superscripts & subscripts ([b8eabd1](https://github.com/OXY2DEV/markview.nvim/commit/b8eabd1e0bc0175bc18fffd9312d77035c281c84))
* Changed list item & tables specification ([3724114](https://github.com/OXY2DEV/markview.nvim/commit/37241141f00a3f0763ea1ace18f522ea6e4f33f4))
* Checkbox now use the `match_string` option ([4fe3790](https://github.com/OXY2DEV/markview.nvim/commit/4fe379080564c3de6b8dcdc5c577891a066a2a82))
* Checkboxes now carry information regarding their list item ([c7385c9](https://github.com/OXY2DEV/markview.nvim/commit/c7385c9cbe7dbc9b61abf48417d5b26170496fd2))
* Default modes now contain command mode ([73b86f5](https://github.com/OXY2DEV/markview.nvim/commit/73b86f562e43b268a3f4ac4b6a21bddc63c928e2))
* Deprecated old checkbox ([afb87e6](https://github.com/OXY2DEV/markview.nvim/commit/afb87e6eb7465f4a92e61e011ef682b2be02eca8))
* Fixed a bug causing visual artifacts with tables in split view ([b2d46d9](https://github.com/OXY2DEV/markview.nvim/commit/b2d46d945ae918978615cd07d4eb2147ef872fa7))
* Fixed a bug not letting attached buffers be re-attached ([a2007c3](https://github.com/OXY2DEV/markview.nvim/commit/a2007c3aad0ca041532c44010dd1871248ac44b8))
* Fixed a bug when using hybrid mode with split view ([4273e03](https://github.com/OXY2DEV/markview.nvim/commit/4273e0372691031ecd1d1d1fb6cbb610f65a0b86))
* Fixed an issue causing hybrid mode not working with latex blocks ([207c39e](https://github.com/OXY2DEV/markview.nvim/commit/207c39ee40af0d4cd7091a53e6303a4882eba462))
* Fixed an issue causing treesitter injections to not work ([9a15f72](https://github.com/OXY2DEV/markview.nvim/commit/9a15f7202b4ff5123fdf0e9cd9e414f0cc3f4a68))
* Fixed block quote title rendering ([6d4863c](https://github.com/OXY2DEV/markview.nvim/commit/6d4863c8575975e99b10c2950e06aebcdaf12ab2))
* Fixed checkbox detection for list items ([39dd746](https://github.com/OXY2DEV/markview.nvim/commit/39dd7467e271621f97d897b09a627e20786c9f6f))
* Fixed definitions for callbacks ([b2d46d9](https://github.com/OXY2DEV/markview.nvim/commit/b2d46d945ae918978615cd07d4eb2147ef872fa7))
* Fixed extmark poaition of code blocks ([5f4e2c3](https://github.com/OXY2DEV/markview.nvim/commit/5f4e2c3c443bacb3f763f100d445d17ed521250c))
* Fixed handling of overlapping table borders ([9f7ff72](https://github.com/OXY2DEV/markview.nvim/commit/9f7ff72827e9a7d12f2662c9430245c02f3cc6f1))
* Fixed how list items are parsed ([17ed16e](https://github.com/OXY2DEV/markview.nvim/commit/17ed16ecee3b67ecc46bf4d60ba04cd35a22b883))
* Fixed incorrect annotations for callout match_string ([2b22590](https://github.com/OXY2DEV/markview.nvim/commit/2b2259009554c1fb5e312c72130e84b87ef6244c))
* Fixed incorrect cursor position on code blocks ([3abd13d](https://github.com/OXY2DEV/markview.nvim/commit/3abd13d483ece69d52e3b5883431995f6f7da5c0))
* Fixed incorrect highlight group for the ] in LaTeX brackets ([4fe3790](https://github.com/OXY2DEV/markview.nvim/commit/4fe379080564c3de6b8dcdc5c577891a066a2a82))
* Fixed incorrect option for n) type list items ([a823191](https://github.com/OXY2DEV/markview.nvim/commit/a823191375205426624a7ed147894e6df8fcffa9))
* Fixed incorrect parameter for footer rendering function ([4e0c8a1](https://github.com/OXY2DEV/markview.nvim/commit/4e0c8a1418f4a03a43842ee2f6decd1214df8473))
* Fixed incorrect width calculation of footnotes ([cc759e8](https://github.com/OXY2DEV/markview.nvim/commit/cc759e8dacc42e96b192271a1092619ae47a2558))
* Fixed indentation of treesitter injections ([9a15f72](https://github.com/OXY2DEV/markview.nvim/commit/9a15f7202b4ff5123fdf0e9cd9e414f0cc3f4a68))
* Fixed list item alignment inside of block quotes ([d28fb24](https://github.com/OXY2DEV/markview.nvim/commit/d28fb24bf47bbd646acbd73df7fe313c72c2435b))
* Fixed mathbf font support ([6d4863c](https://github.com/OXY2DEV/markview.nvim/commit/6d4863c8575975e99b10c2950e06aebcdaf12ab2))
* Fixed merge issue of highlight_groups ([4fe3790](https://github.com/OXY2DEV/markview.nvim/commit/4fe379080564c3de6b8dcdc5c577891a066a2a82))
* Fixed naming of font captures to be more flexible ([aad0149](https://github.com/OXY2DEV/markview.nvim/commit/aad0149767d2d3f1e8beb68833d9bf1c04881cbb))
* Fixed option name typo ([3036694](https://github.com/OXY2DEV/markview.nvim/commit/3036694ee55a2d386122c38baa42acab1ee085bb))
* Fixed overlapping table border issue ([f553e3f](https://github.com/OXY2DEV/markview.nvim/commit/f553e3fa04ae254c5f4d821e1e1281b57fcee652))
* Fixed presets ([3b6f737](https://github.com/OXY2DEV/markview.nvim/commit/3b6f737fd5d23bb53ece827135d382a3dccb1bd2))
* Fixed rendering of code blocks that use markdown inside them ([1f7c120](https://github.com/OXY2DEV/markview.nvim/commit/1f7c120a3fadb1cf2c55d112ff2e77d5f8a6fddf))
* Fixed rendering of list items when padding isn't used ([24ae03e](https://github.com/OXY2DEV/markview.nvim/commit/24ae03e8f80e2647e4fee5f7d4b36c78541a97e2)), closes [#163](https://github.com/OXY2DEV/markview.nvim/issues/163)
* Fixed right padding position of inline codes ([cc759e8](https://github.com/OXY2DEV/markview.nvim/commit/cc759e8dacc42e96b192271a1092619ae47a2558))
* Fixed superscript & subscript parsing ([fbe547c](https://github.com/OXY2DEV/markview.nvim/commit/fbe547c8ff90df2dd2040315a41e30ed5f32e7b4))
* Fixed typo ([6f4a7cd](https://github.com/OXY2DEV/markview.nvim/commit/6f4a7cd57e3ca4dd48ca76938a3d603f52b6be68))
* Fixed typos ([0475053](https://github.com/OXY2DEV/markview.nvim/commit/047505387e6d92669dfb23713cf95efc73f773f2))
* Fixed various bugs with extra mofules ([279040c](https://github.com/OXY2DEV/markview.nvim/commit/279040ce1173f6710a6c740483e0f5c5a484cd43))
* Fixed various typos ([a83f53e](https://github.com/OXY2DEV/markview.nvim/commit/a83f53e9c61669557abb1c00022405b3a7a731e4))
* Fixed visual glitch of headings, list items & checkboxes ([c29ce0f](https://github.com/OXY2DEV/markview.nvim/commit/c29ce0fad68db4a5879eeeadaa6e06865b3a0bf4))
* Fixed wording of annotation ([3d3ea4c](https://github.com/OXY2DEV/markview.nvim/commit/3d3ea4c42f376eb6d9cfe1dddb101c8871580e38))
* Fixed wrong amount of parameters being sent to parser function ([91302d2](https://github.com/OXY2DEV/markview.nvim/commit/91302d24cbbb7e1d39036d10c676aa59cf8a3867))
* Fixes handling of magic characters inside checkboxes ([74b5d60](https://github.com/OXY2DEV/markview.nvim/commit/74b5d60c3c53a6f12ea1c0513ecc4f332c6e7ba1)), closes [#156](https://github.com/OXY2DEV/markview.nvim/issues/156)
* Fixes wrong option name for the * list items ([4fe3790](https://github.com/OXY2DEV/markview.nvim/commit/4fe379080564c3de6b8dcdc5c577891a066a2a82))
* Heading's shift_width has been reverted to 1 ([4fe3790](https://github.com/OXY2DEV/markview.nvim/commit/4fe379080564c3de6b8dcdc5c577891a066a2a82))
* **highlights:** Fixed highlight groups for the plugin ([d7c55c6](https://github.com/OXY2DEV/markview.nvim/commit/d7c55c6a58568b0eb56936ea1bd62469b35ab350))
* **latex:** Removed unnecessary feature `brackets` ([eeb2bde](https://github.com/OXY2DEV/markview.nvim/commit/eeb2bdedfa3677f95306ac5c57971ebae85cc04d))
* Links/Images with list characters are overindented ([a55e185](https://github.com/OXY2DEV/markview.nvim/commit/a55e1853c0ccca7f570d97d74059f1b94ebab3f6))
* Made all parsers optional ([4671de6](https://github.com/OXY2DEV/markview.nvim/commit/4671de67c8c119f5c06f07fb417d9af39e399cf9))
* Made the table renderer use the new table parts spec ([1dc661e](https://github.com/OXY2DEV/markview.nvim/commit/1dc661e68d7772cecaad5e3f333c40e037172fa7))
* name_hl for code blocks has been renamed to language_hl ([05dbce9](https://github.com/OXY2DEV/markview.nvim/commit/05dbce99c44f2f1a95ae2cbd3a74fbf6b8108f44))
* Redraw autocmds are now cached ([d07ebbe](https://github.com/OXY2DEV/markview.nvim/commit/d07ebbedb2d606a5f3b8541dc2f84ad67981ad75))
* Removed `nvim-web-devicons` as a dependency for luarocks ([9c15e30](https://github.com/OXY2DEV/markview.nvim/commit/9c15e30415b73c5f79dca5a16873a2ed80e19a88)), closes [#152](https://github.com/OXY2DEV/markview.nvim/issues/152)
* Removed debug prints ([4f56916](https://github.com/OXY2DEV/markview.nvim/commit/4f5691676f592c885b7c3c59239c1ac693bce18e))
* Removed hard-coded virtual text value for LaTeX code blocks ([417490a](https://github.com/OXY2DEV/markview.nvim/commit/417490a70a4f8106a78109b4da13208916bc9632))
* Removed the message for latex support ([45b9f16](https://github.com/OXY2DEV/markview.nvim/commit/45b9f164b4cd82a5cd151c49bc3fd9495df39a96)), closes [#140](https://github.com/OXY2DEV/markview.nvim/issues/140)
* Removed useless html checker for table cells ([f91feb4](https://github.com/OXY2DEV/markview.nvim/commit/f91feb465414f0d24a86e7169f27a8011090deed)), closes [#160](https://github.com/OXY2DEV/markview.nvim/issues/160)
* Removes rendering of icons when the link starts with an emoji ([7cec2dd](https://github.com/OXY2DEV/markview.nvim/commit/7cec2ddf240ac654daeefe6012cff6fd222394fc))
* **renderer:** Added more custom links ([3f76267](https://github.com/OXY2DEV/markview.nvim/commit/3f762670cdffcc10361c6d3d467b7e0ddbdd6c7b))
* **renderer:** Deprecated "minimal" style of code blocks ([55dec1c](https://github.com/OXY2DEV/markview.nvim/commit/55dec1c0214faa31ba53562a76885656af90a762))
* **renderer:** Fixed html tag parsing ([3f76267](https://github.com/OXY2DEV/markview.nvim/commit/3f762670cdffcc10361c6d3d467b7e0ddbdd6c7b))
* **renderer:** Fixed incorrect concealmemt range for subscripts & superscripts in latex ([ba7b383](https://github.com/OXY2DEV/markview.nvim/commit/ba7b383f74fb1015fb136703f1200b25eda29bfa)), closes [#148](https://github.com/OXY2DEV/markview.nvim/issues/148)
* **renderer:** Subscript & superscripts are now more readable! ([963389b](https://github.com/OXY2DEV/markview.nvim/commit/963389bddf896584324a12a6f3c4d87250289131))
* **renderer:** Symbols now respect subscript & superscript ([963389b](https://github.com/OXY2DEV/markview.nvim/commit/963389bddf896584324a12a6f3c4d87250289131))
* Tables can now have a predefined width ([f139fab](https://github.com/OXY2DEV/markview.nvim/commit/f139fabd38aae0ea6b5ed2537b53237eae533a01))
* Transitioning from hard coded operators to more flexible node based one ([d2a879a](https://github.com/OXY2DEV/markview.nvim/commit/d2a879a79c9ec0aa8a64bae992b4ccb44b4c63ec))
* Updated config ([ea6c780](https://github.com/OXY2DEV/markview.nvim/commit/ea6c780a010fa21f2a804b23b8dc6fc55b4ac978))
* Updated config to follow newer spec ([93dc524](https://github.com/OXY2DEV/markview.nvim/commit/93dc524f99ab9a554a6f4f8390c84c91c96f32a8))
* Updated Setext heading style name ([cea88ba](https://github.com/OXY2DEV/markview.nvim/commit/cea88ba6879056104eb723e7e0d9fe7a1b9daf03))

## [23.1.0](https://github.com/OXY2DEV/markview.nvim/compare/v23.0.0...v23.1.0) (2024-09-09)


### Features

* Ability to toggle hybrid mode ([5738773](https://github.com/OXY2DEV/markview.nvim/commit/573877329dbfa2918f27e47dc5c0e92c06fe400e))


### Bug Fixes

* Added ability to hide escaped charaters ([1aa54de](https://github.com/OXY2DEV/markview.nvim/commit/1aa54de650b703d5f533494159519a9ee4a077e3)), closes [#144](https://github.com/OXY2DEV/markview.nvim/issues/144)
* Callout(s) no longer hide underlying text ([77b9b8c](https://github.com/OXY2DEV/markview.nvim/commit/77b9b8c78cf4dcfc433c37e73171f722cc0a6fe8))
* Checkboxes now hide the list markers ([d283507](https://github.com/OXY2DEV/markview.nvim/commit/d2835077de618d7215bc9aef4c3594497c72b8bf)), closes [#142](https://github.com/OXY2DEV/markview.nvim/issues/142)
* Removed the need to change callbacks to make hybrid mode work. ([5738773](https://github.com/OXY2DEV/markview.nvim/commit/573877329dbfa2918f27e47dc5c0e92c06fe400e))
* Tables now ignore (block_continuation) ([a2594d0](https://github.com/OXY2DEV/markview.nvim/commit/a2594d0df31e6b90a5302730148d535d030b1641))
* Teble renderer now can handle escaped characters ([1aa54de](https://github.com/OXY2DEV/markview.nvim/commit/1aa54de650b703d5f533494159519a9ee4a077e3))

## [23.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v22.1.0...v23.0.0) (2024-09-08)


### ⚠ BREAKING CHANGES

* **renderer:** Added missing Obsidian callouts

### Features

* Added simple Latex support ([92f5320](https://github.com/OXY2DEV/markview.nvim/commit/92f53209eab8e1661cca4a2635b76a5c926d8fad)), closes [#138](https://github.com/OXY2DEV/markview.nvim/issues/138)
* **renderer:** Added missing Obsidian callouts ([ea71a5b](https://github.com/OXY2DEV/markview.nvim/commit/ea71a5bc6e0a0b28af62e2f21d264ddcc466bd51)), closes [#135](https://github.com/OXY2DEV/markview.nvim/issues/135)


### Bug Fixes

* Fixed a bug causing deleted buffers to not be removed from the attached buffers list ([e4b4b9d](https://github.com/OXY2DEV/markview.nvim/commit/e4b4b9d03b90350236ce88f5be723aa5a8610931)), closes [#137](https://github.com/OXY2DEV/markview.nvim/issues/137)
* Fixed how widths are calculated in code blocks ([59c15a2](https://github.com/OXY2DEV/markview.nvim/commit/59c15a2baec56c8fbb3f22151407978c27f389f8))
* Split view no longer loses it's state when changing plugin state with `:Markview ...` ([d6f0cb8](https://github.com/OXY2DEV/markview.nvim/commit/d6f0cb87b8cf8929fa8626f06ff0544b89eb9b7a))

## [22.1.0](https://github.com/OXY2DEV/markview.nvim/compare/v22.0.1...v22.1.0) (2024-08-31)


### Features

* Added split-view to the plugin ([308024c](https://github.com/OXY2DEV/markview.nvim/commit/308024cbcb783fe0c179a18f8e2a7b31406c8a37)), closes [#131](https://github.com/OXY2DEV/markview.nvim/issues/131)


### Bug Fixes

* Fixed a bug causing callbacks to not work. ([6641174](https://github.com/OXY2DEV/markview.nvim/commit/6641174ed030a0d7f305ce860f21097c28560fb9))
* Minor bug fixes for splitView ([3471b7b](https://github.com/OXY2DEV/markview.nvim/commit/3471b7b84b618464aed8e80f35531e5352d3869f))

## [22.0.1](https://github.com/OXY2DEV/markview.nvim/compare/v22.0.0...v22.0.1) (2024-08-28)


### Bug Fixes

* Added support for n) type number list ([a954ec8](https://github.com/OXY2DEV/markview.nvim/commit/a954ec86be1259d547d6fd9c18e8781c8c73c92f)), closes [#129](https://github.com/OXY2DEV/markview.nvim/issues/129) [#121](https://github.com/OXY2DEV/markview.nvim/issues/121)
* Custom links now inherit from `default` value ([a954ec8](https://github.com/OXY2DEV/markview.nvim/commit/a954ec86be1259d547d6fd9c18e8781c8c73c92f))

## [22.0.0](https://github.com/OXY2DEV/markview.nvim/compare/v21.0.1...v22.0.0) (2024-08-26)


### ⚠ BREAKING CHANGES

* Added the ability to use the plugin in other filetypes

### Features

* Added the ability to use the plugin in other filetypes ([e7e91ad](https://github.com/OXY2DEV/markview.nvim/commit/e7e91ad3320c8a3feabba27f5ac79953f99c2632))


### Bug Fixes

* Fixed a bug causing things not to render when scrolling short distances ([8f0b69a](https://github.com/OXY2DEV/markview.nvim/commit/8f0b69a170320c21f4b70517753ddf0aede15055))

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
