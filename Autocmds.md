<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-autocmds.txt",
            "force_write": true,
            "header": {
                "desc": "📞 Autocmds for `markview.nvim`",
                "tag": "markview.nvim-autocmds"
            }
        },
        "markdown": {
            "link_url_modifiers": [
                [ "^#%-extra%-modules", "|markview.nvim-extras|" ],
                [ "^#%-presets", "|markview.nvim-presets|" ]
            ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            }
        }
    }
-->
<!--markdoc_ignore_start-->
## 📞 Autocmds
<!--markdoc_ignore_end-->

`markview.nvim` emits various *autocmd events* during different parts of the rendering allowing users to extend the plugin's functionality.

```lua
vim.api.nvim_create_autocmd("User", {
    pattern = "MarkviewAttach",
    callback = function (event)
        --## This will have all the data you need.
        local data = event.data;

        vim.print(data);
    end
})
```

>[!NOTE]
> Autocmds are executed **after** callbacks!

Currently emitted autocmds are,

## MarkviewAttach

Called when attaching to a buffer.

Arguments,

+ `buffer`, integer
  The buffer that's being attached to.

+ `windows`, integer[]
  List of windows attached to `buffer`.

## MarkviewDetach

Called when detaching from a buffer.

Arguments,

+ `buffer`, integer
  The buffer that's being detached from.

+ `windows`, integer[]
  List of windows attached to `buffer`.

## MarkviewDisable

Called when disabling previews in a buffer.

Arguments,

+ `buffer`, integer
  The buffer whose the preview was disabled.

+ `windows`, integer[]
  List of windows attached to `buffer`.

## MarkviewEnable

Called when enabling previews in a buffer.

Arguments,

+ `buffer`, integer
  The buffer whose the preview was enabled.

+ `windows`, integer[]
  List of windows attached to `buffer`.

## MarkviewSplitviewClose

Called when the splitview window is closed. Called *before* splitview is closed.

Arguments,

+ `source`, integer
  The buffer whose contents are being shown.

+ `preview_buffer`, integer
  The buffer that's showing the preview.

+ `preview_window`, integer
  The window where the `preview_buffer` is being shown.

## MarkviewSplitviewOpen

Called when the splitview window is opened.

Arguments,

+ `source`, integer
  The buffer whose contents are being shown.

+ `preview_buffer`, integer
  The buffer that's showing the preview.

+ `preview_window`, integer
  The window where the `preview_buffer` is being shown.

