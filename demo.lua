local ccf = {}

ccf.default = function(name, param)
    return false, minetest.colorize("red", "[kuto]: fallback function triggered")
end

ccf.legacy = function(name, param)
    local formspec = {
        "formspec_version[4]",
        "size[10,10]",
        kuto.component.button("kuto_button", {
            pos = {1, 1},
            size = {2.3, 0.9},
            label = "kb_name",
        }),
        kuto.component.card("kuto_card", {
            pos = {1, 3},
            image = "kuto_card_demo.png",
            title_name = "title_name",
            title = "test 123 this is a test to see how long this goes on for",
            content_name = "content_name",
            content = "test message to see how well the hypertext element line wraps bla bla",
            label = "kb_name",
        }),
    }

    minetest.show_formspec(name, "kuto:test", table.concat(formspec, ""))
end

ccf.astt = function(name, param)
    local formspec = {
        formspec_version = 4,
        {
            type = "size",
            w = 10,
            h = 10,
        },
        {
            type = "label",
            x = 1,
            y = 1,
            label = "test label",
        },
        kuto.component.button2("kuto_button", {
            pos = {1, 3},
            size = {2.3, 0.9},
            label = "kb_name",
            cname = "kb_cname",
            on_event = function(form, player, element)
                local cindex = kuto.get_index_by_name(form, "kb_cname")
                form[cindex] = {type = "label", x=1, y=3, label = "test button label"}

                return form
            end
        }),

    }

    minetest.show_formspec(name, "kuto:test", formspec)
end

minetest.register_chatcommand("kuto", {
    description = "kuto ui elements test",
    func = function(name, param)
        local split = param:split(" ")
        if not ccf[split[1]] then return ccf["default"](name, "") end
        return ccf[split[1]](name, split[2] or "")
    end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if not formname:find("kuto") then return end

    --debug
    minetest.chat_send_player(player:get_player_name(), dump(fields))
end)