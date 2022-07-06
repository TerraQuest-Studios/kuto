kuto.registered_astk = {}

kuto.get_element_by_name = formspec_ast.get_element_by_name

function kuto.get_index_by_name(tree, name)
    if type(tree) ~= "table" then return end

    for key, element in pairs(tree) do
        if type(element) == "table" and element.name and element.name == name then
            return key
        end
    end
end

function text_to_fs_units(text, dir)
    if dir == "w" then return (#text*0.15)+1 else return 1 end
end

--note this is terrible hard coded
local function insert_styles(form, styles)
    local headers = {
        size = true,
        position = true,
        anchor = true,
        no_prepend = true,
        real_cordinates = true,
        padding=true
    }
    local cindex = 0
    local fs = {}

    for key, val in pairs(form) do
        if type(val) == "number" and not tonumber(key) then
            fs[key] = val
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

    for val in formspec_ast.walk(form) do
        if type(val) == "table" then
            if val.w == "auto" then val.w = text_to_fs_units(val.label, "w") end
            if val.h == "auto" then val.h = text_to_fs_units(val.label, "h") end
        end

        if type(val) == "table" and val.props then
            table.insert(styles, {type = "style", selectors = val.selectors or {val.name}, props = val.props})
        elseif type(val) == "table" and val.type and val.type == "kstyle" and val.kstyles then
            --css like styling
            for selector, attributes in pairs(val.kstyles) do
                if selector:match("^#") then
                    styles[#styles+1] = {type = "style", selectors = {selector:sub(2, -1)}, props = attributes}
                elseif selector:match("^%.") then
                    --batch up elements for one fs style element rather than be wasteful
                    local class_elems = {}
                    for elem in formspec_ast.walk(form) do
                        if elem.class and elem.class:find(selector:sub(2, -1)) then
                            class_elems[#class_elems+1] = elem.name
                        end
                    end
                    styles[#styles+1] = {type = "style", selectors = class_elems, props = attributes}
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
        kuto.registered_astk[playername] = fs
    end

    old_sf(playername, formname, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local pname = player:get_player_name()
    if not kuto.registered_astk[pname] then return end

    if fields.quit then kuto.registered_astk[player:get_player_name()] = nil return end

    local keys = {}
    for key, val in pairs(fields) do table.insert(keys, key) end

    local element = kuto.get_element_by_name(kuto.registered_astk[pname], keys[1])

    if element and element.on_event then
        --on_event(form, player, element)
        local form = element.on_event(kuto.registered_astk[pname], player, element)
        if form then minetest.show_formspec(player, formname, form) end
    end
end)