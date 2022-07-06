# Element Types

see https://gitlab.com/luk3yx/minetest-formspec_ast/-/blob/master/elements.yaml

# Element extensions

this mod extends the default elements to add a prop field to handle 
styling in the element rather than a seperate style element. see example

```lua
props = {
    border = false,
    bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
    bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
    bgimg_middle = "4,4",
}
```

elements can also have a class field, for adding elements to a list to be stilled
the same. see css like styling for more info. example:

```lua
class = "kstyle_unique_button unused_demo_class",
```

for buttons, there is an optional on_event callback for handling when the button is 
selected. see example

```lua
on_event = function(form, player, element)
    local cindex = kuto.get_index_by_name(form, "kuto_button")
    form[cindex] = {type = "label", x=1, y=3, label = "test button label"}

    return form
end
```

elements with that require width, height, and have a label can now set w/h to "auto"
```lua
w = "auto",
h = "auto",
```

# css like styling
this mod via a custom kstyle element allows you to add targeted styling of elements 
in a css manor

```lua
{
    type = "kstyle",
    kstyles = {
        --styles here
    }
}
```

## method 1: unique selectors

you can do #elementid, but in this case its #elementname

```lua
["#kstyle_unique_button"] = {
    bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
    bgimg_middle = "4,4",
},
```

## method 2: class selectors

you can do .classname to apply styles to an element. see
element type class

```lua
[".kstyle_unique_button"] = {
    bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
    bgimg_middle = "4,4",
},
```

# Quality of life features

`minetest.show_formspec(player, formname, fs)` is extended to allow you to pass astk formspecs straight into it like a normal formspec, no conversion before hand needed

# Components

TODO  
Currently: see compontents.lua/demo.lua

# API

`kuto.get_index_by_name(tree, name)`  
returns you the index of the provided element name in your astk 

`kuto.get_element_by_name`  
is an alias of `formspec_ast.get_element_by_name` at this time