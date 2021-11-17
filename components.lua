kuto.component = {}

function kuto.component.button(name, def)
    local background = "kuto_button.png^[combine:16x16^\\[noalpha\\^[colorize:#ffffff"
    local formspec = {
        "container[".. def.pos[1] .. "," .. def.pos[2] .. "]",
        "style["..name..";border=false;bgimg="..background.."70;bgimg_hovered="..background.."90;bgimg_middle=4,4]",
        "button[0,0;"..def.size[1]..","..def.size[2]..";"..name..";"..def.label.."]",
        "container_end[]",
    }
    return table.concat(formspec, "")
end

function kuto.component.button2(name, def)
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
        "container[".. def.pos[1] .. "," .. def.pos[2] .. "]",
        "background9[0,0;6,1.6;kuto_button.png;false;4,4]",
        "image[0.05,0.05;1.5,1.5;"..def.image.."]",
        "image[1.55,0.05;4.45,1.5;[combine:16x16^\\[noalpha\\^[colorize:#ffffff70]",
        "hypertext[2,0.2;3.9,0.5;"..def.title_name..";<style size=20><b>"..title.."</b></style>]",
        "hypertext[2,0.7;3.9,0.8;"..def.content_name..";<normal>"..content.."</normal>]",
        "style["..name..";border=false]",
        "button[0,0;6,1.6;"..name..";]",
        "container_end[]",
    }
    return table.concat(formspec, "")
end