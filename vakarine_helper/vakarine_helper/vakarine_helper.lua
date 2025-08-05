local addon_name = "VAKARINE_HELPER"
local addon_name_lower = string.lower(addon_name)
local author = "Rakka"
local ver = "1.0.6"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addon_name] = _G["ADDONS"][author][addon_name] or {}
local g = _G["ADDONS"][author][addon_name]

g.settings_file_loc = string.format('../addons/%s/settings.json', addon_name_lower)
local acutil = require("acutil")

function VAKARINE_HELPER_ON_INIT(addon, frame)

    g.addon = addon
    g.frame = frame

    create_global_environments(false)

    addon:RegisterMsg("BUFF_ADD", "on_buff_add");

    local inv_frame = ui.GetFrame('inventory')
    local inventory_gbox = inv_frame:GetChild("inventoryGbox")
    local position_x = inventory_gbox:GetWidth() - 108
    local position_y = inventory_gbox:GetHeight() - 288

    local vakarine_btn = inv_frame:CreateOrGetControl("button", "vakarine_btn", position_x - 339, position_y - 43, 100, 30)
    AUTO_CAST(vakarine_btn)
    vakarine_btn:SetText("{ol}{#FFFFFF}Vakarine")
    vakarine_btn:SetSkinName("test_red_button")
    vakarine_btn:SetEventScript(ui.LBUTTONUP, "activate_vakarine")
    vakarine_btn:SetTextTooltip("Unequip/Equip items, necklace last")
    vakarine_btn:ShowWindow(1)

    local ignore_buffs_btn = inv_frame:CreateOrGetControl("button", "ignore_buffs_btn", position_x - 239, position_y - 43, 50, 30)
    AUTO_CAST(ignore_buffs_btn)
    ignore_buffs_btn:SetText("{ol}" .. (g.ignore_buff and "{#00EC00}ON" or "{#FFFFFF}OFF"))
    ignore_buffs_btn:SetSkinName(g.ignore_buff and "baseyellow_btn" or "test_gray_button")
    ignore_buffs_btn:SetEventScript(ui.LBUTTONUP, "on_event_ignore_buffs_btn")
    ignore_buffs_btn:SetTextTooltip("Ignore HP Recovery From: Small Elixir of HP Recovery and Fruit of HP Recovery.")
    ignore_buffs_btn:ShowWindow(1)

    CHAT_SYSTEM("Vakarine helper " .. ver .. " inicializado. Desenvolvido por " .. author .. ".")

end

function activate_vakarine()

    local inv_frame = ui.GetFrame("inventory")
    local vakarine_btn = GET_CHILD_RECURSIVELY(inv_frame, "vakarine_btn")
    vakarine_btn:ShowWindow(0)

    save_items()

    if not contains("RH", g.equip_item_saved_list) or not contains("LH", g.equip_item_saved_list) then
        ui.SysMsg("Uma ou ambas as armas primárias não foram encontradas.")
        vakarine_btn:ShowWindow(1)
        return
    end

    unequip_items()

end

function contains(value, list)

    for _, v in pairs(list) do
        if v == value then
            return true
        end
    end
    return false

end

function create_global_environments(on_development)

    if not g.script_delay or on_development then
        g.script_delay = 0.2
    end

    if not g.ignore_buff or on_development then
        g.ignore_buff = false
    end

    if not g.ignored_buff_list or on_development then
        g.ignored_buff_list = {
            4139, -- Small Elixir of HP Recovery
            4724, -- Fruit of HP Recovery
        }
    end

    if not g.spot_list or on_development then
        g.spot_list = {
            [3] = "SHIRT",
            [4] = "GLOVES",
            [5] = "BOOTS",
            [6] = "SHOULDER",
            [7] = "BELT",
            [8] = "RH",
            [9] = "LH",
            [14] = "PANTS",
            [17] = "RING1",
            [18] = "RING2",
            [19] = "NECK",
            [30] = "RH_SUB",
            [31] = "LH_SUB",    
        }
    end

end

function equip_items()

    local inv_frame = ui.GetFrame("inventory")

    if tonumber(USE_SUBWEAPON_SLOT) == 1 then
        DO_WEAPON_SLOT_CHANGE(inv_frame, 1)
    else
        DO_WEAPON_SWAP(inv_frame, 1)
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "SHIRT" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "GLOVES" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "BOOTS" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "RH" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "LH" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "PANTS" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "RING1" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "RING2" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "RH_SUB" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "LH_SUB" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end
    
    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "BELT" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "SHOULDER" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    for iesid, spot_name in pairs(g.equip_item_saved_list) do
        local equip_item = session.GetInvItemByGuid(tonumber(iesid));
        if spot_name == "NECK" and equip_item ~= nil then
            ITEM_EQUIP(equip_item.invIndex, spot_name)
            ReserveScript("equip_items()", g.script_delay)
            return
        end
    end

    local vakarine_btn = GET_CHILD_RECURSIVELY(inv_frame, "vakarine_btn")
    vakarine_btn:ShowWindow(1)

end

function on_buff_add(frame, msg, argStr, buffid)

    if g.ignore_buff and contains(buffid, g.ignored_buff_list) then
        packet.ReqRemoveBuff(buffid)
    end

end

function on_event_ignore_buffs_btn()

    g.ignore_buff = not g.ignore_buff

    local inv_frame = ui.GetFrame("inventory")
    local ignore_buffs_btn = GET_CHILD_RECURSIVELY(inv_frame, "ignore_buffs_btn")

    ignore_buffs_btn:SetText("{ol}" .. (g.ignore_buff and "{#00EC00}ON" or "{#FFFFFF}OFF"))
    ignore_buffs_btn:SetSkinName(g.ignore_buff and "baseyellow_btn" or "test_gray_button")

end

function save_items()

    g.equip_item_saved_list = {}
    local equip_item_list = session.GetEquipItemList();
    local equip_item_list_count = equip_item_list:Count();

    for i = 0, equip_item_list_count - 1 do
        local equip_item = equip_item_list:GetEquipItemByIndex(i);
        local spot_name = item.GetEquipSpotName(equip_item.equipSpot)
        local iesid = tostring(equip_item:GetIESID())

        if iesid ~= "0" and contains(spot_name, g.spot_list) then
            g.equip_item_saved_list[iesid] = spot_name
        end
    end

end

function unequip_items()

    local equip_item_list = session.GetEquipItemList();
    local equip_item_list_count = equip_item_list:Count();

    for i = 0, equip_item_list_count - 1 do
        local equip_item = equip_item_list:GetEquipItemByIndex(i);
        local spot_name = item.GetEquipSpotName(equip_item.equipSpot);
        local iesid = tostring(equip_item:GetIESID())

        if iesid ~= "0" and contains(spot_name, g.spot_list) then
            item.UnEquip(equip_item.equipSpot)
            ReserveScript("unequip_items()", g.script_delay)
            return
        end
    end

    equip_items()

end