kuto = {}
kuto.modpath = minetest.get_modpath("kuto")

dofile(kuto.modpath .. "/monkey_patching.lua")
dofile(kuto.modpath .. "/components.lua")
dofile(kuto.modpath .. "/demo.lua")

kuto.modpath = nil