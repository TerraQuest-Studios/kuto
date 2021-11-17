kuto.registered_ast = {}

local old_sf = minetest.show_formspec

function minetest.show_formspec(player, formname, fs)
    local playername = player
    local formspec = fs

    if type(player) == "userdate" then
        playername = player:get_player_name()
    end
    if type(fs) == "table" then
        formspec = formspec_ast.unparse(fs)
        kuto.registered_ast[formname] = fs
    end

    old_sf(playername, formname, formspec)
end