local cfg = MjsLua.config("BondVoice", {
    Enabled = { default = true, desc = "Play all character voices regardless of bond level requirements" },
})

local function log(msg)
    MjsLua.log("[bond_voice] " .. msg)
end

local originals = setmetatable({}, { __mode = "k" })

local function unlock(row)
    if originals[row] == nil then
        originals[row] = { level = row.level_limit, bond = row.bond_limit }
    end
    row.level_limit = 0
    row.bond_limit = 0
end

local function restore()
    for row, limits in pairs(originals) do
        row.level_limit = limits.level
        row.bond_limit = limits.bond
        originals[row] = nil
    end
end

MjsLua.hook("ExcelMgr.GetData", function(orig, tableName, sheetName, id)
    local data = orig(tableName, sheetName, id)
    if cfg.Enabled and tableName == "voice" and sheetName == "sound" and type(data) == "table" then
        for _, row in pairs(data) do
            if type(row) == "table" then
                unlock(row)
            end
        end
    end
    return data
end)

MjsLua.onConfigChange(cfg, "Enabled", function(enabled)
    if not enabled then
        restore()
    end
end)

log("loaded")
