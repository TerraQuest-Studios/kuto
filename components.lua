kuto.component = {}

function kuto.component.button(name, def)
    local formspec = {
        type = "container",
        name = def.cname,
        x = def.pos[1],
        y = def.pos[2],
        {
            type = "button",
            x = 0,
            y = 0,
            w = def.size[1],
            h = def.size[2],
            name = name,
            label = def.label,
            on_event = def.on_event,
            props = {
                border = false,
                --luk3yx claims no escaping is fine, if this breaks, blame him
                bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                bgimg_middle = "4,4",
            }
        }
    }

    return formspec
end

function kuto.component.card(name, def)
    local title = string.sub(def.title,1,24)
    local content = string.sub(def.content,1,60)
    local formspec = {
        type = "container",
        name = def.cname,
        x = def.pos[1],
        y = def.pos[2],
        {
            type = "background9",
            x = 0,
            y = 0,
            w = 6,
            h = 1.6,
            texture_name = "kuto_button.png",
            auto_clip = false,
            --middle = "4,4"
            middle_x = 4,
            middle_y = 4,
        },
        {
            type = "image",
            x = 0.05,
            y = 0.05,
            w = 1.5,
            h = 1.5,
            texture_name = def.image
        },
        {
            type = "image",
            x = 1.55,
            y = 0.05,
            w = 4.45,
            h = 1.5,
            texture_name = "[combine:16x16^[noalpha^[colorize:#ffffff70"
        },
        {
            type = "hypertext",
            x = 2,
            y = 0.02,
            w = 3.9,
            h = 0.5,
            name = def.title_name,
            text = "<style size=20><b>"..title.."</b></style>"
        },
        {
            type = "hypertext",
            x = 2,
            y = 0.7,
            w = 3.9,
            h = 0.8,
            name = def.content_name,
            text = "<normal>"..content.."</normal>"
        },
        {
            type = "button",
            x = 0,
            y = 0,
            w = 6,
            h = 1.6,
            name = name,
            props = {
                border = false
            }
        }
    }
    return formspec
end