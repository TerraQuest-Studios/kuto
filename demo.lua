local ccf = {}

ccf.default = function(name, param)
    return false, minetest.colorize("red", "[kuto]: fallback function triggered")
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
        {
            type = "button",
            x = 3,
            y = 1,
            w = 2,
            h = 1,
            name = "kstyle_unique_button",
            label = "unique kstyle",
        },
        {
            type = "button",
            x = 6,
            y = 1,
            w = "auto",
            h = "auto",
            name = "kstyle_class_button_2",
            label = "class kstyle",
            class = "kstyle_unique_button",
        },
        {
            type = "button",
            x = 6,
            y = 2.5,
            w = 2,
            h = 1,
            name = "kstyle_class_button",
            label = "class kstyle",
            class = "kstyle_unique_button unused_demo_class",
        },
        kuto.component.button("kuto_button", {
            pos = {1, 3},
            size = {2.3, 0.9},
            btn_text = "click me",
            btn_name = "kuto_btn",
            on_event = function(form, player, element)
                local cindex = kuto.get_index_by_name(form, "kuto_button")
                form[cindex] = {type = "label", x=1, y=3, label = "test button label"}

                return form
            end
        }),
        kuto.component.card("kuto_card", {
            pos = {1, 4},
            icon = "kuto_card_demo.png",
            ttl_name = "title_name",
            ttl_text = "test 123 this is a test to see how long this goes on for",
            ctt_name = "content_name",
            ctt_text = "test message to see how well the hypertext element line wraps bla bla",
            btn_name = "kuto_card_btn",
            on_event = function(form, player, element)
                minetest.chat_send_player(player:get_player_name(), minetest.colorize("yellow", "[kuto]: test output"))
            end
        }),
        {
            type = "kstyle",
            kstyles = {
                ["#kstyle_unique_button"] = {
                    bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                    bgimg_middle = "4,4",
                },
                [".kstyle_unique_button"] = {
                    bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                    bgimg_middle = "4,4",
                },
            }
        }

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