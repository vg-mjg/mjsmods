local function log(msg)
    MjsLua.log("[decensor] " .. msg)
end

local function unchangedText(text)
    if text == nil then
        return ""
    end
    return text
end

MjsLua.hook("Taboo.Test", function(orig, self, text)
    return nil
end)

MjsLua.hook("Tools.StrWithoutForbidden", function(orig, text, splitOnPunctuation)
    return unchangedText(text)
end)

MjsLua.hook("Tools.StrContainsForbidden", function(orig, text)
    return false
end)

MjsLua.hook("Tools.MatchRoomStrContainsForbidden", function(orig, text)
    return unchangedText(text)
end)

MjsLua.hook("Tools.MatchPartyNameHandleForbidden", function(orig, text)
    return unchangedText(text)
end)

log("loaded")
