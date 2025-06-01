# 💻 Dev documentations

Mostly for extending plugin functionalities.

## 📑 States

Plugin states are stored in `require("markview").states`.

```lua
--- Table containing various plugin states.
---@class mkv.state
---
--- List of attached buffers.
---@field attached_buffers integer[]
---
--- Buffer local states.
---@field buffer_states { [integer]: { enable: boolean, hybrid_mode: boolean? } }
---
--- Source buffer for hybrid mode.
---@field splitview_source? integer
--- Preview buffer for hybrid mode.
---@field splitview_buffer? integer
--- Preview window for hybrid mode.
---@field splitview_window? integer
markview.state = {
	attached_buffers = {},
	buffer_states = {},

	splitview_buffer = nil,
	splitview_source = nil,
	splitview_window = nil
};
```

>[!WARNING]
> `splitview_buffer` might not be `nil` even after closing splitview as there's no point in creating a new buffer every time.

## 🚀 Internal functions

>[!TIP]
> The sub-command implementation can be found in `require("markview").commands`.

Commonly used functions can be found inside `require("markview").actions`. These are,

- `__exec_callback`,
  Safely executes a given callback.

  Usage: `markview.actions.__exec_callback(callback, ...)`
  + `callback`, callback name.
  + `...` arguments.

- `__is_attached`,
  Checks if `markview` is attached to a buffer or not.

  Usage: `markview.actions.__is_attached(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

  Return: `boolean`

- `__is_enabled`,
  Checks if `markview` is enabled on a buffer or not.

  Usage: `markview.actions.__is_enabled(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

  Return: `boolean`

- `__splitview_setup`
  Sets up the buffer & window for `splitview`.

  Usage: `markview.actions.__splitview_setup()`

>[!WARNING]
> **Anti-pattern:** Prevents users from forcefully closing the splitview window.

------

- `attach`
  Attaches `markview` to a buffer.

  Usage: `markview.actions.attach(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

- `detach`
  Detaches `markview` to a buffer.

  Usage: `markview.actions.detach(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

------

- `enable`
  Enables previews for the given buffer.

  Usage: `markview.actions.enable(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

- `disable`
  Disables previews for the given buffer.

  Usage: `markview.actions.disable(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

------

- `hybridEnable`
  Enables *hybrid mode* for the given buffer.

  Usage: `markview.actions.hybridEnable(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

- `hybridDisable`
  Disables *hybrid mode* for the given buffer.

  Usage: `markview.actions.hybridDisable(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

------

- `splitOpen`
  Opens splitview for the given buffer.

  Usage: `markview.actions.splitOpen(buffer)`
  + `buffer`, buffer ID(defaults to current buffer).

- `splitClose`
  Closes any open splitview window.

## ✨ Manual previews

You can manually show previews via these functions,

- `markview.render(buffer, state, config)`
  Renders preview on `buffer`(defaults to current buffer).

  + `buffer`, buffer ID.
  + `state`, buffer state(`{ enable: boolean, hybrid_mode: boolean }).
  + `config`, custom config to use(doesn't merge with user config).

- `markview.clear(buffer)`
  Clears previews of `buffer`(defaults to current buffer).

------

- `markview.clean()`
  Detaches `markview` from any invalid buffer.

------

Also available in vimdoc, `:h markview.nvim-dev`.

