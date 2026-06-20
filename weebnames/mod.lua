local cfg = MjsLua.config("Weebnames", {
  Variant = { default = "weeb", choices = { "weeb", "nya" }, desc = "Name set: weeb (romaji) or nya (nya)" },
  Level = { default = "low",  choices = { "low", "high" }, desc = "Weebiness: low (short) or high (full names)" },
})

local YAKU = {
  { fan = 1, desc = 103, weeb = { "Menzenchin Tsumohou", "Menzen Tsumo" } },
  { fan = 2, desc = 101, weeb = "Riichi" },
  { fan = 3, desc = 109, weeb = "Chankan", nya = "Nyankan" },
  { fan = 4, desc = 110, weeb = "Rinshan Kaihou", nya = "Rinnyan Kaihou" },
  { fan = 5, desc = 111, weeb = "Haitei Raoyue" },
  { fan = 6, desc = 112, weeb = "Houtei Raoyui" },
  { fan = 7, weeb = "Haku" },
  { fan = 8, weeb = "Hatsu" },
  { fan = 9, weeb = "Chun" },
  { fan = 10, desc = 104, weeb = { "Jikaze", "Seat Wind" } },
  { fan = 11, desc = 105, weeb = { "Bakaze", "Prevalent Wind" } },
  { fan = 12, desc = 102, weeb = { "Tanyaochuu", "Tanyao" } },
  { fan = 13, desc = 108, weeb = "Iipeikou" },
  { fan = 14, desc = 107, weeb = "Pinfu", nya = "Nyanfu" },
  { fan = 15, desc = 209, weeb = { "Honchantaiyaochuu", "Chanta" }, nya = { "Honchantaiyaochuu", "Nyanta" } },
  { fan = 16, desc = 210, weeb = { "Ikkitsuukan", "Ittsuu" } }, -- or "Ittsu"
  { fan = 17, desc = 211, weeb = "Sanshoku Doujun", nya = "Nyanshoku Doujun" },
  { fan = 18, desc = 201, weeb = "Double Riichi" },
  { fan = 19, desc = 202, weeb = "Sanshoku Doukou", nya = "Nyanshoku Doukou" },
  { fan = 20, desc = 203, weeb = "Sankantsu", nya = "Nyankantsu" },
  { fan = 21, desc = 204, weeb = { "Toitoihou", "Toitoi" } },
  { fan = 22, desc = 205, weeb = "Sanankou", nya = "Nyanyankou" },
  { fan = 23, desc = 206, weeb = "Shousangen", nya = "Shounyangen" },
  { fan = 24, desc = 207, weeb = "Honroutou" },
  { fan = 25, desc = 208, weeb = { "Chiitoitsu", "Chiitoi" } },
  { fan = 26, desc = 302, weeb = { "Junchan Taiyao", "Junchan" }, nya = { "Junchan Taiyao", "Junnyan" } },
  { fan = 27, desc = 303, weeb = "Honitsu" },
  { fan = 28, desc = 301, weeb = "Ryanpeikou", nya = "Nyanpeikou" },
  { fan = 29, desc = 401, weeb = "Chinitsu" },
  { fan = 30, desc = 113, weeb = "Ippatsu" },
  { fan = 31, desc = 114, weeb = "Dora", nya = "Doraneko" },
  { fan = 32, desc = 115, weeb = "Akadora", nya = "Akadoraneko" },
  { fan = 33, weeb = "Uradora", nya = "Uradoraneko" },
  { fan = 34, desc = 116, weeb = "Kita", nya = "Pei Nya" },
  { fan = 35, desc = 601, weeb = "Tenhou" },
  { fan = 36, desc = 602, weeb = "Chiihou" },
  { fan = 37, desc = 603, weeb = "Daisangen", nya = "Dainyangen" },
  { fan = 38, desc = 604, weeb = "Suuankou", nya = "Suunyankou" },
  { fan = 39, desc = 605, weeb = "Tsuuiisou" },
  { fan = 40, desc = 606, weeb = "Ryuuiisou" },
  { fan = 41, desc = 607, weeb = "Chinroutou" },
  { fan = 42, desc = 608, weeb = "Kokushi Musou" },
  { fan = 43, desc = 609, weeb = "Shousuushii" },
  { fan = 44, desc = 610, weeb = "Suukantsu" },
  { fan = 45, desc = 611, weeb = "Chuuren Poutou", nya = "Nyanren Poutou" },
  { fan = 46, weeb = "Paarenchan" },
  { fan = 47, desc = 703, weeb = "Junsei Chuuren Poutou", nya = "Junsei Nyanren Poutou" },
  { fan = 48, desc = 701, weeb = "Suuankou Tanki", nya = "Suunyankou Tanki" },
  { fan = 49, desc = 702, weeb = "Kokushi Musou Juusan Menmachi", nya = "Kokushi Juusan Nyanmachi" },
  { fan = 50, desc = 704, weeb = "Daisuushii" },
  { fan = 51, weeb = "Tsubame-gaeshi" },
  { fan = 52, weeb = "Kanburi", nya = "Nyanburi" },
  { fan = 53, weeb = "Shiiaruraotai" },
  { fan = 54, weeb = "Uumensai", nya = "Uunyansai" },
  { fan = 55, weeb = "Sanrenkou", nya = "Nyanrenkou" },
  { fan = 56, weeb = "Iishoku Sanjun", nya = "Iishoku Nyanjun" },
  { fan = 57, weeb = "Iipinmoyue" },
  { fan = 58, weeb = "Chuupinraoyui" },
  { fan = 59, weeb = "Renhou" },
  { fan = 60, weeb = "Daisharin" },
  { fan = 61, weeb = "Daichikurin" },
  { fan = 62, weeb = "Daisuurin" },
  { fan = 63, weeb = "Ishinouenimosannen" },
  { fan = 64, weeb = "Daichisei" },
  { desc = 106, weeb = { "Yakuhai - Sangen", "Dragons" } },
  { desc = 501, str = 2105, weeb = "Nagashi Mangan", nya = "Nagashi Manyan" },
  { desc = 801, weeb = "Suufon Renda" },
  { desc = 802, weeb = "Suukaikan" },
  { desc = 803, weeb = "Kyuushuu Kyuuhai" },
  { desc = 804, weeb = "Suucha Riichi" },
}

local function log(msg)
  MjsLua.log("[weebnames] " .. msg)
end

local function resolveName(row, variant, level)
  local name = row[variant] or row.weeb
  if type(name) == "table" then
    name = (level == "high") and name[1] or name[2]
  end
  return name
end

local TABLES = {
  fan = { rowKey = "fan", field = "name_en" },
  fandesc = { rowKey = "desc", field = "name_en" },
  str = { rowKey = "str", field = "en" },
}

local overrides = {}
local fields = {}
for tableName, spec in pairs(TABLES) do
  fields[tableName] = spec.field
end

local function rebuild()
  local count = 0
  for tableName in pairs(TABLES) do
    overrides[tableName] = {}
  end
  for _, row in ipairs(YAKU) do
    local name = resolveName(row, cfg.Variant, cfg.Level)
    if name then
      for tableName, spec in pairs(TABLES) do
        local id = row[spec.rowKey]
        if id and id ~= 0 then
          overrides[tableName][id] = name
        end
      end
      count = count + 1
    end
  end
  log(string.format("loaded %d yaku (variant=%s, level=%s)", count, cfg.Variant, cfg.Level))
end

rebuild()

MjsLua.onConfigChange(cfg, "Variant", rebuild)
MjsLua.onConfigChange(cfg, "Level", rebuild)

MjsLua.hook("ExcelMgr.GetData", function(orig, tableName, sheetName, id)
  local row = orig(tableName, sheetName, id)
  if row then
    local byId = overrides[tableName]
    if byId then
      local name = byId[id]
      if name then
        row[fields[tableName]] = name
      end
    end
  end
  return row
end)
