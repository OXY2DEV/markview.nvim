# markview.nvim

This is a test file.

If you want to configure the plugin check the `renderer.lua` file. Currently it can't be configured with `setup()`.

Plugin is in it's alpha phase. Use at your own risk.





---









Normally headers with icons(provided by plugins) look like this.

󰼎 Header 1
╰──┤ The icon is being squeezed to death and looks ugly.

So, I changed it. Now it looks like this.

# Header 1

And yes, customisable signs are also provided.

Individual customisation for headers is also possible.

## Header 2

### Header 3

#### Header 4

##### Header 5

###### Header 6


From icons to background color, sign everything is individually customisable.


[Hi](https://test.com)


I also changed how block quotes look.

> This is a `block quote`.

I also added support for callouts.

>[!NOTE]
> This is a note.

>[!TIP]
> This is a tip.

You can also make custom callouts.

>[!CUSTOM]
> This is a custom callout.

Block quotes can also support mutiple borders & colors.

> 0
> 1
> 2
> 3
> 4
> 5
> 6



Code blocks have also been reworked.

Icons and language are shown along with optional sign column.

```lua
print("Hello world");
```

```c
#import <stdio.h>

void main() {
    printf("Hello world");
}
```

```html
<html>
    <body>Hello world</body>
</html>
```
Unfortunately, this breaks indents in `normal mode`. So, it's not for everyone.





A [Hyperlink](https://example.com) in a normal line

[Source](https://example.com)


![IMG](https://image.com)



This is an inline `code`.

- Hi

+ Hi

* Hi


- [ ] A checkbox
- [X] A checkbox
-  ✔ 
-  ✘ 



| Name        | Num | Num |
|-------------|-----|-----|
| 1           | 2   | 2   |
| 3           | 4   | 4   |



| Name   | Num | Num |
|--------|-----|-----|
| 1      | 2   | 2   |
| 3      | 4   | 4   |


| Name   | Num |
|--------|-----|
| 1      | 2   |
| 1      | 2   |
| 1      | 2   |
| 1      | 2   |
| 3      | 4   |

