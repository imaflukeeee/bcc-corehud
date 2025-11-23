Config                          = {}

-- คีย์ภาษาที่ใช้โดย locale.lua (ต้องมีอยู่ในตาราง Locales)
Config.defaultlang              = 'en_lang'

-- พฤติกรรม HUD ฝั่งผู้เล่น (Client)
Config.AutoShowHud              = true         -- ตั้งเป็น false เพื่อให้ต้องพิมพ์ /togglehud เองเมื่อเกิด
Config.UpdateInterval           = 5000         -- อัตราการรีเฟรช Core เป็นมิลลิวินาที
Config.NeedsUpdateInterval      = 5000         -- ช่วงเวลา (ms) ที่ระบบความหิว/กระหาย/อุณหภูมิจะทำงาน
Config.LowCoreWarning           = 25.0         -- เรียกใช้เอฟเฟกต์สถานะเมื่อ Core ลดลงต่ำกว่าเปอร์เซ็นต์นี้
Config.devMode                  = false         -- เปิดใช้งานการบันทึก Log ฝั่งผู้เล่นแบบละเอียดเมื่อเป็น true
Config.HorseDirtyThreshold      = 45            -- ระดับ Attribute ที่/สูงกว่า ซึ่งม้าจะแสดงไอคอนสกปรก (ตั้งค่า false เพื่อปิดใช้งาน)
Config.TemperatureColdThreshold = -3.0         -- อุณหภูมิโลก (เซลเซียส) ที่/ต่ำกว่า ซึ่งไอคอนหนาวจะปรากฏ
Config.TemperatureHotThreshold  = 26.0         -- อุณหภูมิโลก (เซลเซียส) ที่/สูงกว่า ซึ่งไอคอนร้อนจะปรากฏ
Config.TemperatureMin           = -15.0        -- อุณหภูมิโลกต่ำสุดที่แมปกับ Core (เซลเซียส)
Config.TemperatureMax           = 40.0         -- อุณหภูมิโลกสูงสุดที่แมปกับ Core (เซลเซียส)
Config.AlwaysShowTemperature    = true         -- เมื่อเป็น true Core อุณหภูมิจะแสดงแม้ไม่มีเอฟเฟกต์ร้อน/หนาว
Config.NeedsAutoDecay           = true         -- เมื่อเป็น true และไม่มีทรัพยากร needs ภายนอกที่กำหนดค่าไว้ ความหิว/กระหายจะลดลงตามเวลา
Config.NeedsDecayStartDelay     = 300.0        -- วินาทีที่รอก่อนที่ค่าความต้องการจะเริ่มลดลงหลังจากเติมเต็ม (5 นาที)

-- ตัวคูณเหล่านี้จะลดค่าสถานะตามกิจกรรมต่อวินาที (Tick)
Config.ActivityMultipliers      = {
    idle   = { hunger = 0.05, thirst = 0.07 }, -- ใช้อย่างต่อเนื่องขณะยืนนิ่งหรือแทบไม่ขยับ
    walk   = { hunger = 0.10, thirst = 0.20 }, -- การเคลื่อนไหวเบาๆ (เดิน)
    run    = { hunger = 0.15, thirst = 0.20 }, -- วิ่งปกติ
    sprint = { hunger = 0.15, thirst = 0.20 }, -- วิ่งเต็มฝีเท้า
    coast  = { hunger = 0.15, thirst = 0.20 }, -- ค่าสำรองเริ่มต้นเมื่อยืนอยู่แต่ระบบไม่ระบุว่านิ่ง (Idle)
    swim   = { hunger = 0.15, thirst = 0.20 },  -- การว่ายน้ำ
    mounted = { hunger = 0.08, thirst = 0.08 } -- ขี่ม้า
}

Config.InitialNeedValue         = 100.0        -- ค่าความหิว/กระหายเริ่มต้นเมื่อเกิด (ใช้เฉพาะเมื่อเปิดระบบลดค่า Local)

Config.StressSettings           = {
    enabled                 = true,
    minimumSpeedMph         = 35.0,
    speedCheckIntervalMs    = 2000,
    speedStressMin          = 1,
    speedStressMax          = 3,
    shootingEnabled         = true,
    shootingCheckIntervalMs = 250,
    shootingStressChance    = 0.25,
    shootingStressMin       = 1,
    shootingStressMax       = 3,
    effectMinimumSeverity   = 25.0,
    effectCooldownMs        = 3000,
    ragdollSeverity         = 85.0,
    ragdollCooldownMs       = 7000,
    shakeIntensityMin       = 0.05,
    shakeIntensityMax       = 0.35,
    damageEnabled           = true,
    damageSeverityThreshold = 85.0,
    damageDelayMinutes      = 60.0,
    damageTickIntervalMs    = 15000,
    damageAmount            = 3
}

-- ความเสียหายต่อเลือด/ความกระหายน้ำจากอุณหภูมิแบบพื้นฐาน
Config.MinTemp                  = -5.0                                       -- อุณหภูมิที่ต่ำกว่าระดับนี้จะทำให้เลือดลดในแต่ละรอบการทำงาน (Tick)
Config.MaxTemp                  = 31.0                                       -- อุณหภูมิที่สูงกว่าระดับนี้จะทำให้เลือดลดในแต่ละรอบการทำงาน (Tick)
Config.RemoveHealth             = 5                                          -- จำนวนเลือดที่ถูกหักออกต่อรอบเมื่ออยู่นอกช่วงอุณหภูมิที่ปลอดภัย
Config.HotTempThirstDrain       = 1.5                                        -- เปอร์เซ็นต์ความกระหายน้ำที่ลดลงต่อรอบเมื่ออุณหภูมิสูงกว่า Config.MaxTemp
Config.TempWarningCooldown      = 10.0                                       -- ระยะเวลา (วินาที) ระหว่างการแจ้งเตือนความร้อนเกินแต่ละครั้ง
Config.DoHealthDamageFx         = true                                       -- แสดงเอฟเฟกต์หน้าจอ "MP_Downed" ขณะได้รับความเสียหายจากอุณหภูมิ
Config.DoHealthPainSound        = true                                       -- เล่นเสียงร้องเจ็บปวดเมื่อได้รับความเสียหายจากอุณหภูมิ
Config.StarvationDamageDelay    = 120.0                                      -- ระยะเวลา (วินาที) ที่หลอดอาหารและน้ำต้องหมดเกลี้ยงก่อนจะเริ่มลดเลือด (ใส่ 0 เพื่อปิด)
Config.StarvationDamageInterval = 10.0                                       -- ระยะห่าง (วินาที) ของการลดเลือดแต่ละครั้งเมื่อเริ่มหิวตาย/ขาดน้ำตาย
Config.StarvationDamageAmount   = 3                                          -- จำนวนเลือดที่ลดลงในแต่ละรอบเมื่อหิวตาย/ขาดน้ำตาย (ใส่ 0 เพื่อปิด)

-- ตัวบ่งชี้เสียง
Config.EnableVoiceCore          = true                             -- เปิด/ปิดแถบวัดระยะเสียง
Config.VoiceMaxRange            = 50.0                             -- ระยะเสียงสูงสุด (เมตร) ที่ใช้คำนวณวงแหวนรอบไอคอน
Config.VoiceProximitySteps      = { 2.0, 15.0, 50.0 }              -- กระซิบ / ปกติ / ตะโกน
Config.VoiceDefaultStepIndex    = 2                                -- เริ่มต้นที่ระยะ 15 เมตร (ระดับปกติ)
Config.VoiceCycleControl        = 0x446258B6                       -- ปุ่มตัวอย่าง/การควบคุม (PGUP)

-- ตัวบ่งชี้ตู้จดหมาย (ทำงานร่วมกับ bcc-mailbox)
Config.EnableMailboxCore        = false         -- แสดง Core ข้อความเมื่อเป็น true
Config.MailboxMaxMessages       = 10            -- จำนวนที่ทำให้วงแหวนเต็ม (10 ข้อความที่ยังไม่อ่าน = เต็ม)
Config.MailboxUpdateInterval    = 30000         -- ความถี่ในการรีเฟรชจำนวนจากเซิร์ฟเวอร์ (มิลลิวินาที)

Config.Notify                   = "feather-menu"

-- ตัวบ่งชี้ค่าความสะอาด
Config.EnableCleanStatsCore     = false  -- แสดง Core ความสะอาดเมื่อเป็น true
Config.MinCleanliness           = 60.0  -- เกณฑ์เปอร์เซ็นต์ที่ระบุว่าผู้เล่นตัวสกปรก
Config.CleanRate                = 0.01  -- เปอร์เซ็นต์ความสะอาดที่ลดลงต่อวินาทีเมื่อไม่ได้ทำความสะอาด
Config.CleanPenaltyInterval     = 10.0  -- ระยะเวลา (วินาที) ระหว่างการลดเลือดแต่ละครั้งเมื่อค่าความสะอาดต่ำกว่าเกณฑ์
Config.CleanHigherIsClean       = false -- เมื่อเป็น true ค่า Attribute ยิ่งสูงหมายถึงยิ่งสะอาด
Config.CleanWarningInterval     = 60.0  -- ระยะเวลา (วินาที) ระหว่างการแจ้งเตือนเรื่องสุขอนามัยแต่ละครั้ง
Config.FlyEffect                = {
    enabled    = true,
    dict       = 'scr_mg_cleaning_stalls',
    name       = 'scr_mg_stalls_manure_flies',
    offset     = { x = 0.2, y = 0.0, z = -0.4 },
    rotation   = { x = 0.0, y = 0.0, z = 0.0 },
    axis       = { x = 0.0, y = 0.0, z = 0.0 },
    scale      = 1.0,
    boneMale   = 413,
    boneFemale = 464
}

-- ตัวบ่งชี้เลือดไหล
Config.EnableBleedCore          = true
Config.BleedCore                = {
    CheckInterval         = 1000, -- ระยะเวลา (มิลลิวินาที) ระหว่างการตรวจสอบสถานะเลือดไหลอัตโนมัติ
    DamageRefreshCooldown = 2500,  -- ดีเลย์ขั้นต่ำระหว่างการตรวจสอบเลือดไหลที่เกิดจากการได้รับความเสียหาย
    ShowWhenHealthy       = true,  -- เมื่อเป็น true ช่องสถานะเลือดไหลจะแสดงอยู่ตลอดแม้ว่าจะไม่ได้เลือดไหลก็ตาม
    UseBccMedical         = true   -- เมื่อเป็น true HUD จะดึงข้อมูลเลือดไหลจาก bcc-medical; ตั้งค่าเป็น false เมื่อใช้งานร่วมกับระบบอื่น
}

Config.NeedWarningThreshold     = 10.0  -- เปอร์เซ็นต์ที่เมื่อถึงหรือต่ำกว่า จะแจ้งเตือนความหิว/กระหาย
Config.NeedWarningInterval      = 120.0 -- ระยะเวลา (วินาที) ระหว่างการแจ้งเตือนความหิว/กระหายแต่ละครั้ง

-- คำสั่ง (Commands)
Config.CommandToggleHud         = 'hud'        -- คำสั่งสลับการแสดงผล HUD ทั้งหมด
Config.CommandLayout            = 'hudlayout'  -- คำสั่งเข้าสู่โหมดแก้ไขเลย์เอาต์
Config.CommandPalette           = 'hudpalette' -- คำสั่งเปิดเมนูจานสี
Config.CommandClearFx           = 'clearfx'    -- คำสั่งล้างเอฟเฟกต์หน้าจอที่ค้าง (เช่น จอแดง)
Config.CommandHeal              = 'hudheal'    -- คำสั่งรักษา/ให้อาหารตัวเอง (สำหรับแอดมิน/ดีบัก)

-- ตัวบ่งชี้สกุลเงิน/XP (ค่าที่ได้รับผ่าน events/exports)
Config.EnableMoneyCore          = false -- แสดงจำนวนเงินปัจจุบัน
Config.EnableGoldCore           = false -- แสดงยอดทอง
Config.EnableExpCore            = false -- แสดงค่าประสบการณ์
Config.EnableTokensCore         = false -- แสดงโทเคนหรือแต้มพรีเมียม

-- โลโก้ / ตัวบ่งชี้ลายน้ำ
Config.EnableLogoCore           = false      -- ตั้งเป็น true เพื่อแสดงช่องโลโก้ที่ลากไปมาได้
Config.LogoImage                = 'logo.png' -- Path/URL ที่ให้บริการโดย NUI สำหรับรูปภาพโลโก้

-- Database persistence (requires oxmysql)
Config.SaveInterval             = 15000 -- ดีเลย์ขั้นต่ำระหว่างการบันทึก snapshot ของผู้เล่นแต่ละคน (มิลลิวินาที)

Config.NeedItems                = Config.NeedItems or {}

if type(AddNeedItems) ~= 'function' then
    function AddNeedItems(list)
        if type(list) ~= 'table' then return end
        for _, entry in ipairs(list) do
            Config.NeedItems[#Config.NeedItems + 1] = entry
        end
    end
end

Config.Prompts = { 
    Drop = "Drop",                    
    DropKey = 0x3B24C470,              -- F
    Smoke = "Smoke",
    Chewing = "Chew",
    SmokeKey = 0x07B8BEAF,             -- LMB
    Change = "Change",
    ChangeKey = 0xD51B784F,            -- E
}
