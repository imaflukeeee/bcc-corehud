BccUtils = exports["bcc-utils"].initiate()

-- เพิ่มการประกาศตัวแปร VORPcore
local VORPcore = {}
TriggerEvent("getCore", function(core) VORPcore = core end)

if Config.devMode then
    function devPrint(...)
        local args = { ... }
        for i = 1, #args do
            if type(args[i]) == "table" then
                args[i] = json.encode(args[i])
            elseif args[i] == nil then
                args[i] = "nil"
            else
                args[i] = tostring(args[i])
            end
        end
        print("^1[DEV MODE] ^4" .. table.concat(args, " ") .. "^0")
    end
else
    function devPrint(...) end
end

function Notify(message, typeOrDuration, maybeDuration)
    -- ตั้งค่าเริ่มต้น
    local notifyType = "info"
    local notifyDuration = 4000

    -- ตรวจสอบอาร์กิวเมนต์
    if type(typeOrDuration) == "string" then
        notifyType = typeOrDuration
        notifyDuration = tonumber(maybeDuration) or 4000
    elseif type(typeOrDuration) == "number" then
        notifyDuration = typeOrDuration
    end

    -- กำหนดรูปแบบแจ้งเตือนของ VORP
    local title = "Notification"
    local dict = "menu_textures"
    local icon = "menu_icon_info"
    local color = "COLOR_WHITE"

    if notifyType == "success" then
        title = "Success"
        icon = "menu_icon_tick"
        color = "COLOR_GREEN"
    elseif notifyType == "error" then
        title = "Error"
        icon = "menu_icon_cross"
        color = "COLOR_RED"
    elseif notifyType == "warning" then
        title = "Warning"
        icon = "menu_icon_alert"
        color = "COLOR_YELLOW"
    end

    -- เรียกใช้ NotifyLeft ถ้ามี ถ้าไม่มีให้ใช้ NotifyRightTip
    if VORPcore and VORPcore.NotifyLeft then
        VORPcore.NotifyLeft(title, message, dict, icon, notifyDuration, color)
    elseif VORPcore and VORPcore.NotifyRightTip then
        VORPcore.NotifyRightTip(message, notifyDuration)
    else
        -- กรณี VORPcore ยังไม่โหลด ให้ปริ้นท์เตือน
        print("^1[BCC-CoreHUD] Error: VORPcore not found for notifications^0")
    end
end