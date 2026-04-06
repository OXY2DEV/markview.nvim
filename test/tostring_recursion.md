; Bold/italic wrapping inline elements — tostring recursion

### Bold + link

| Kind | Short | Long |
|------|-------|------|
| Bold + link | **[bold link](https://example.com)** | **[bold link with long URL](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-combined-with-links-and-images)** |
| Italic + link | *[italic link](https://example.com)* | *[italic link with long URL](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-combined-with-links-and-images)* |
| Bold-italic + link | ***[both](https://example.com)*** | ***[both with long URL](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-combined-with-links-and-images)*** |

### Bold + image

| Kind | Short | Long |
|------|-------|------|
| Bold + image | **![icon](https://example.com/i.svg)** | **![a]( https://raw.githubusercontent.com/nvim-treesitter/playground/master/assets/screenshot.png)** |
| Italic + image | *![icon](https://example.com/i.svg)* | *![a](https://raw.githubusercontent.com/nvim-treesitter/playground/master/assets/screenshot.png)* |

### Bold + code

| Kind | Short | Long |
|------|-------|------|
| Bold + code | **`short`** | **`vim.api.nvim_buf_set_extmark(buffer, ns, row, col, opts)`** |
| Italic + code | *`short`* | *`vim.api.nvim_buf_set_extmark(buffer, ns, row, col, opts)`* |

### Mixed nesting

| Description | Content |
|-------------|---------|
| Bold wrapping link + code | **[link](https://example.com) and `code`** |
| Plain bold (no nesting) | **just bold text** |
| Plain italic | *just italic text* |
| No emphasis | [link](https://example.com) then `code` |
