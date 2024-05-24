local parameters = NFS.load(SDM_0s_Stuff_Mod.path.."config.lua")()
local space_jokers = parameters.space_jokers

local sj_list= {}
local temp_string = ""
local words = 2
local i = 0
for _, v in pairs(space_jokers) do
    if i < words then
        temp_string = temp_string .. "{s:0.8}" .. v .. ", "
        i = i + 1
    end
    if i >= words or next(space_jokers, _) == nil then
        if next(space_jokers, _) == nil then
            temp_string = temp_string:sub(1, -3)
        end
        table.insert(sj_list, temp_string)
        temp_string = ""
        i = 0
    end
end

function SDM_0s_Stuff_Mod.process_loc_text()
    G.localization.misc.dictionary.k_halved_ex = "Halved!"
    G.localization.misc.dictionary.k_stone = "Stone"
    G.localization.misc.dictionary.k_signed_ex = "Signed!"
    G.localization.misc.dictionary.k_breached_ex = "Breached!"
    G.localization.misc.dictionary.k_shared_ex = "Shared!"
    G.localization.misc.v_dictionary.a_hand = "+#1# Hand"
    G.localization.descriptions.Other.space_jokers = {
        name = "Space Jokers",
        text = sj_list
    }
    G.localization.descriptions.Other.chaos_exceptions = {
        name = "Exceptions",
        text = {
            "Score round, score goal,",
            "hand level and descriptions",
        }
    }
    G.localization.descriptions.Other.perishable_no_debuff = {
        name = "Perishable",
        text = {
            "Debuffed after",
            "{C:attention}#1#{} rounds"
        }
    }
end

return