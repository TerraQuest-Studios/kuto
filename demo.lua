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
        --[[
        kuto.button("kuto_dialog_button", {
            pos = {4, 1},
            size = {2.3, 0.9},
            label = "show dialog",
        }),
        --]]
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

    --functional
    --[[
    if fields.kuto_dialog_button then
        local form = table.copy(formspec)
        local dialog = kuto.component.dialog("kuto_dialog", {
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