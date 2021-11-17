kuto = {}

function kuto.button(name, def)
    local background = "kuto_button.png^[combine:16x16^\\[noalpha\\^[colorize:#ffffff"
    local formspec = {
        "container[".. def.pos[1] .. "," .. def.pos[2] .. "]",
        "style["..name..";border=false;bgimg="..background.."70;bgimg_hovered="..background.."90;bgimg_middle=4,4]",
        "button[0,0;"..def.size[1]..","..def.size[2]..";"..name..";"..def.label.."]",
        "container_end[]",
    }
    return table.concat(formspec, "")
end

function kuto.card(name, def)
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

function kuto.strip(fs_table, element)
    for key, snippet in pairs(fs_table) do
        if string.find(snippet, element) then
            local split = snippet:split("]")
            for skey, item in pairs(split) do
                if string.find(item, element) then split[skey] = "" end
            end
            fs_table[key] = table.concat(split, "]").."]"
        end
    end
end

--[[
function kuto.dialog(name, def)
    --dialog size and form size
    local ds = {6,4}
    local fs = def.form_size
    local pos = {(fs[1]-ds[1])/2, (fs[2]-ds[2])/2}

    local title = string.sub(def.title,1,15)
    local content = string.sub(def.content,1,110)
    local formspec = {
        "",
        "container["..pos[1]..","..pos[2].."]",
        "image[0,0;"..ds[1]..","..ds[2]..";[combine:16x16^\\[noalpha\\^[colorize:#ffffff]",
        "hypertext[0.4,0.4;3.9,0.5;"..def.title_name..";<style size=20 color=blue><b>"..title.."</b></style>]",
        "hypertext[0.8,1.3;4.5,1.2;"..def.content_name..";<style color=black><normal>"..content.."</normal></style>]",
        --"button[]",

        "container_end[]",
    }

    if def.enable_blank then formspec[1] = "image[0,0;100,100;[combine:16x16^\\[noalpha\\^[colorize:#ffffff90]" end

    return table.concat(formspec, "")
end
--]]

local formspec = {
    "formspec_version[4]",
    "size[10,10]",
    kuto.button("kuto_button", {
        pos = {1, 1},
        size = {2.3, 0.9},
        label = "kb_name",
    }),
    --[[
    kuto.button("kuto_dialog_button", {
        pos = {4, 1},
        size = {2.3, 0.9},
        label = "show dialog",
    }),
    --]]
    kuto.card("kuto_card", {
        pos = {1, 3},
        image = "kuto_card_demo.png",
        title_name = "title_name",
        title = "test 123 this is a test to see how long this goes on for",
        content_name = "content_name",
        content = "test message to see how well the hypertext element line wraps bla bla",
        label = "kb_name",
    }),
}

minetest.register_chatcommand("kuto_test", {
    description = "kuto ui elements test",
    func = function(name, param)
        minetest.show_formspec(name, "kuto:test", table.concat(formspec, ""))
    end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "kuto:test" then return end

    --debug
    minetest.chat_send_player(player:get_player_name(), dump(fields))

    --functional
    --[[
    if fields.kuto_dialog_button then
        local form = table.copy(formspec)
        local dialog = kuto.dialog("kuto_dialog", {
            enable_blank = true,
            form_size = {10,10},
            title_name = "title_name",
            title = "test dialog",
            content_name = "content_name",
            content = "this is a test content message lets see how stuff spaces out, etc, who knows,
                 maybe this will work out, maybe not, yada, yada",
        })
        table.insert(form, dialog)
        minetest.show_formspec(player:get_player_name(), formname, table.concat(form, ""))
    end
    --]]
end)