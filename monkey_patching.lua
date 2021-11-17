kuto.registered_ast = {}

kuto.get_element_by_name = formspec_ast.get_element_by_name

function kuto.get_index_by_name(tree, name)
    if type(tree) ~= "table" then return end

    for key, element in pairs(tree) do
        if type(element) == "table" and element.name and element.name == name then
            return key
        end
    end
end

--note this is terrible hard coded
local function insert_styles(form, styles)
    local headers = {size = true, position = true, anchor = true, no_prepend = true, real_cordinates = true}
    local cindex = 0
    local fs = {}

    for key, val in pairs(form) do
        if type(val) == "string" then
            table.insert(fs, val)
            cindex = key
        elseif type(val) == "table" and val.type and headers[val.type] then
            table.insert(fs, val)
            cindex = key
        end
    end

    for _, val in pairs(styles) do
        table.insert(fs, val)
    end

    cindex = cindex+1
    for i=cindex, #form do
        table.insert(fs, form[i])
    end

    return fs
end

function kuto.convert_to_ast(form)
    local styles = {}

    for key, val in pairs(form) do
        if type(val) == "table" and val.props then
            table.insert(styles, {type = "style", selectors = val.selectors or {val.name}, props = val.props})
        end
        --use recursion for this in the future for multiple level nesting
        if type(val) == "table" and val.type and val.type:find("container") then
            for _, cval in pairs(val) do
                if type(cval) == "table" and cval.props then
                    table.insert(
                        styles,
                        {type = "style", selectors = cval.selectors or {cval.name}, props = cval.props}
                    )
                end
            end
        end
    end

    local fs = insert_styles(form, styles)
    return fs
end

local old_sf = minetest.show_formspec

function minetest.show_formspec(player, formname, fs)
    local playername = player
    local formspec = fs

    if type(player) == "userdata" then
        playername = player:get_player_name()
    end
    if type(fs) == "table" then
        formspec = formspec_ast.unparse(kuto.convert_to_ast(fs))
        kuto.registered_ast[formname] = fs
    end

    old_sf(playername, formname, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if not kuto.registered_ast[formname] then return end

    if fields.quit then kuto.registered_ast[formname] = nil return end

    local keys = {}
    for key, val in pairs(fields) do table.insert(keys, key) end

    local element = kuto.get_element_by_name(kuto.registered_ast[formname], keys[1])
    if element and element.on_event then
        --on_event(form, player, element)
        local form = element.on_event(kuto.registered_ast[formname], player, element)
        if form then minetest.show_formspec(player, formname, form) end
    end
end)