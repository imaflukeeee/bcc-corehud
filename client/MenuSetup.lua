local CORE_KEYS = {
    { key = 'health',        label = 'Health' },
    { key = 'stamina',       label = 'Stamina' },
    { key = 'hunger',        label = 'Hunger' },
    { key = 'thirst',        label = 'Thirst' },
    { key = 'stress',        label = 'Stress' },
    { key = 'messages',      label = 'Messages' },
    { key = 'clean_stats',   label = 'Cleanliness' },
    { key = 'temperature',   label = 'Temperature' },
    { key = 'horse_health',  label = 'Horse Health' },
    { key = 'horse_stamina', label = 'Horse Stamina' },
    { key = 'horse_dirt',    label = 'Horse Dirtiness' },
    { key = 'voice',         label = 'Voice' },
}

local PALETTE = {}
local LAST_PALETTE_SNAPSHOT = nil

-- Helpers
local function clamp(v, lo, hi)
    v = tonumber(v) or 0; if v < lo then return lo end; if v > hi then return hi end; return v
end

local function hsl(h, s, l, a)
    h = clamp(math.floor(h + 0.5), 0, 360)
    s = clamp(math.floor(s + 0.5), 0, 100)
    l = clamp(math.floor(l + 0.5), 0, 100)
    if a ~= nil then return ('hsla(%d, %d%%, %d%%, %.2f)'):format(h, s, l, clamp(a, 0, 1)) end
    return ('hsl(%d, %d%%, %d%%)'):format(h, s, l)
end

local function computePaletteEntry(hue, sat)
    return {
        accent     = hsl(hue, sat, 58),
        icon       = '#ffffff',
        background = hsl(hue, math.floor(sat * 0.45), 18, 0.6),
        track      = hsl(hue, math.max(12, math.floor(sat * 0.35)), 85, 0.35),
        border     = hsl(hue, math.max(20, math.floor(sat * 0.75)), 70, 0.45),
        shadow     = '0 18px 28px rgba(8, 13, 23, 0.45)',
    }
end

local function buildHudPayload()
    local out = {}
    for _, spec in ipairs(CORE_KEYS) do
        local k = spec.key
        local e = PALETTE[k] or { hue = 0, saturation = 0 }
        out[k] = computePaletteEntry(e.hue, e.saturation)
    end
    out.default = computePaletteEntry(0, 0)
    return { type = 'palette', palette = out }
end

local function sendPaletteToHud()
    SendNUIMessage(buildHudPayload())
end

local function requestPaletteFromServer()
    local result = BccUtils.RPC:CallAsync('bcc-corehud:palette:request', {})
    if result and type(result) == 'table' then
        for _, spec in ipairs(CORE_KEYS) do
            local k = spec.key
            local val = result[k] or {}
            PALETTE[k] = { hue = tonumber(val.hue) or 0, saturation = tonumber(val.saturation) or 0 }
        end
        LAST_PALETTE_SNAPSHOT = result
        sendPaletteToHud()
    end
end

-- Init
AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then
        CreateThread(function() Wait(1000); requestPaletteFromServer(); end)
    end
end)

RegisterNUICallback('paletteReady', function(_, cb)
    if LAST_PALETTE_SNAPSHOT then sendPaletteToHud() else requestPaletteFromServer() end
    if cb then cb('ok') end
end)

-- ===========================================
-- คำสั่ง /hudsettings และ Callbacks
-- ===========================================
RegisterCommand('hudsettings', function()
    -- เตรียมข้อมูลสีปัจจุบัน ส่งไปให้หน้าเมนู
    local payload = {}
    for _, spec in ipairs(CORE_KEYS) do
        local k = spec.key
        payload[k] = PALETTE[k] or { hue = 0, saturation = 0 }
    end
    
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'open_settings', palette = payload })
end)

RegisterNUICallback('closeSettings', function(_, cb)
    SetNuiFocus(false, false)
    if cb then cb('ok') end
end)

RegisterNUICallback('previewPalette', function(data, cb)
    if data and data.key then
        PALETTE[data.key] = { hue = data.hue, saturation = data.saturation }
        sendPaletteToHud()
    end
    if cb then cb('ok') end
end)

RegisterNUICallback('savePalette', function(data, cb)
    if data and data.snapshot then
        for k, v in pairs(data.snapshot) do
            PALETTE[k] = { hue = v.hue, saturation = v.saturation }
        end
        sendPaletteToHud()
        BccUtils.RPC:CallAsync('bcc-corehud:palette:save', { snapshot = PALETTE, reason = 'manual_save' })
    end
    if cb then cb('ok') end
end)

RegisterNUICallback('toggleHudCommand', function(_, cb)
    if ToggleUI then ToggleUI() end
    if cb then cb('ok') end
end)

RegisterNUICallback('resetLayoutCommand', function(_, cb)
    BccUtils.RPC:CallAsync('bcc-corehud:layout:reset', {})
    TriggerEvent('bcc-corehud:layout:apply', nil)
    if cb then cb('ok') end
end)

RegisterNUICallback('healPlayerCommand', function(_, cb)
    ExecuteCommand('hudheal')
    if cb then cb('ok') end
end)