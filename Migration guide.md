# Migrating to latest version

Here's the major changes in version `v25`.

- Simpler highlight group customisation.

  ```lua
  {
    --- Old version
    highlight_groups = {},

    --- Highlight group sets can now be specified
    --- with their name.
    --- e.g. "light", "dark", "dynamic"
    highlight_groups = "dynamic"
  }
  ```

- Automatically setting up hybrid mode callbacks.
  Hybrid mode can now be set up without changing the callback(s).

- "github" heading style renamed to "decorated".
  ```lua
  setext_1 = {
      style = "decorated"
  }
  ```

- Custom block quote option name changes,
  - `callout_preview` → `preview`.
  - `callout_preview_hl` → `preview_hl`.
  - `custom_title` → `title`.
  - `custom_icon` → `icon`.

- `pending` checkbox state has been moved to `custom` states.
  ```lua
  custom = {
    { match_string = "-", icon = "◯", hl = "CheckboxPending" }
  }
  ```
- Custom checkbox option name changes.
  - `match` → `match_string`.

- Custom links option name change.
  - `match` → `match_string`.

- Table structure has been changed.


