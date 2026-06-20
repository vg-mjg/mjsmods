local function log(msg)
    MjsLua.log("[friendly_uncle] " .. msg)
end

local function pack(...)
    return { n = select("#", ...), ... }
end

local function unpackResults(results)
    return unpack(results, 1, results.n)
end

local function realAccountId(accountId)
    return accountId ~= nil and accountId ~= 0
end

local function encodeAccountId(accountId)
    if not realAccountId(accountId) or not LuaTools or not LuaTools.EncodeAccountId2 then
        return nil
    end

    local encoded = LuaTools.EncodeAccountId2(accountId)
    if encoded == nil or encoded == "" then
        return nil
    end

    return tostring(encoded)
end

local function setProfileAccountId(self)
    if not self or not self.btnCopyID or not self.textID then
        return
    end

    local encoded = encodeAccountId(self.accountId)
    if not encoded then
        return
    end

    local isSelf = GameMgr and GameMgr.Inst and self.accountId == GameMgr.Inst.account_id
    self.btnCopyID.gameObject:SetActive(true)

    if isSelf then
        self.textID.text = (Tools and Tools.StrOfLocalization and Tools.StrOfLocalization(2459) or "My ID:") .. encoded
    else
        self.textID.text = "ID:" .. encoded
    end
end

local function copyProfileAccountId(accountId)
    local encoded = encodeAccountId(accountId)
    if not encoded then
        return
    end

    if Tools and Tools.CopyText then
        Tools.CopyText(encoded)
    elseif UnityEngine and UnityEngine.GUIUtility then
        UnityEngine.GUIUtility.systemCopyBuffer = encoded
    else
        return
    end

    if UIMgr and UIMgr.Inst and UI_light_tip and Tools and Tools.StrOfLocalization then
        UIMgr.Inst:ShowUI(UI_light_tip.className, nil, { str = Tools.StrOfLocalization(2125) })
    end
end

local function getPlayerAtLocalPosition(localPos)
    if not DesktopMgr or not DesktopMgr.Inst then
        return nil
    end

    local dm = DesktopMgr.Inst
    if not dm.player_datas or not dm.localPosition2Seat then
        return nil
    end

    local seat = dm:localPosition2Seat(localPos)
    if not seat or seat <= 0 then
        return nil
    end

    return dm.player_datas[seat]
end

local function showDesktopPlayerInfo(self, localPos)
    if not DesktopMgr or not DesktopMgr.Inst or not UIMgr or not UIMgr.Inst or not UI_PlayerInfo then
        return
    end

    if self.seeInfoLock then
        return
    end

    local dm = DesktopMgr.Inst
    local mode = GameUtility and GameUtility.EMJ_Mode
    if mode and dm.mode == mode.tutorial then
        return
    end

    if mode and dm.mode ~= mode.paipu and not dm.gameing then
        return
    end

    local player = getPlayerAtLocalPosition(localPos)
    local accountId = player and player.account_id
    if not realAccountId(accountId) then
        return
    end

    self.seeInfoLock = true

    local payload = {
        accountId = accountId,
        category = dm.rule_mode and dm.rule_mode + 1 or nil,
        tabType = nil,
        nameServiceType = GameUtility
            and GameUtility.ENameFilterServiceType
            and GameUtility.ENameFilterServiceType.LAZY
            or nil,
    }

    local gameConfig = dm.game_config
    if gameConfig and gameConfig.category == 1 then
        payload.tabType = 2
    elseif gameConfig and gameConfig.category == 2 then
        local meta = gameConfig.meta
        local matchMode = meta
            and ExcelMgr
            and ExcelMgr.GetData
            and ExcelMgr.GetData("desktop", "matchmode", meta.mode_id)
        if matchMode and matchMode.room >= 100 then
            payload.tabType = 3
        end
    end

    UIMgr.Inst:ShowUI(UI_PlayerInfo.className, function()
        self.seeInfoLock = false
    end, payload)
end

local function enablePaipuHeadInfo(headbtn, localPos)
    if not headbtn then
        return
    end

    local player = getPlayerAtLocalPosition(localPos)
    local accountId = player and player.account_id
    local enabled = realAccountId(accountId)

    headbtn.locking = false
    headbtn.enable = false
    headbtn.showinfo = enabled
    headbtn.showemj = false
    headbtn.showchange = true

    if headbtn.transform then
        headbtn.transform.gameObject:SetActive(enabled)
    end
    if headbtn.btn_seeinfo then
        headbtn.btn_seeinfo.gameObject:SetActive(false)
    end
    if headbtn.btn_report then
        headbtn.btn_report.gameObject:SetActive(false)
    end
    if headbtn.btn_banemj then
        headbtn.btn_banemj.gameObject:SetActive(false)
    end
    if headbtn.btn_change then
        headbtn.btn_change.gameObject:SetActive(false)
    end
end

local function enablePaipuDesktopInfoButtons(self)
    if not DesktopMgr or not DesktopMgr.Inst or not GameUtility or not GameUtility.EMJ_Mode then
        return
    end

    if DesktopMgr.Inst.mode ~= GameUtility.EMJ_Mode.paipu then
        return
    end

    if not self or not self.player_infos then
        return
    end

    for localPos = 1, #self.player_infos do
        local info = self.player_infos[localPos]
        if info and info.headbtn then
            enablePaipuHeadInfo(info.headbtn, localPos)
        end
    end
end

local function isPaipuReview()
    return DesktopMgr
        and DesktopMgr.Inst
        and GameUtility
        and GameUtility.EMJ_Mode
        and DesktopMgr.Inst.mode == GameUtility.EMJ_Mode.paipu
end

MjsLua.hook("GameMgr.CheckPaiPu", function(orig, self, uuid, accountId, paipuConfig, anonymous, urlAccess, extra)
    return orig(self, uuid, accountId, paipuConfig, false, urlAccess, extra)
end)

MjsLua.hook("UI_DesktopInfo.Btn_SeeInfo", function(orig, self, localPos)
    if
        DesktopMgr
        and DesktopMgr.Inst
        and GameUtility
        and GameUtility.EMJ_Mode
        and DesktopMgr.Inst.mode == GameUtility.EMJ_Mode.paipu
    then
        return showDesktopPlayerInfo(self, localPos)
    end

    return orig(self, localPos)
end)

MjsLua.hook("UI_DesktopInfo.RefreshSeat", function(orig, self, changedSeat)
    local results = pack(orig(self, changedSeat))
    enablePaipuDesktopInfoButtons(self)
    return unpackResults(results)
end)

MjsLua.hook("UI_DesktopInfo.InitRoom", function(orig, self, ...)
    local results = pack(orig(self, ...))
    enablePaipuDesktopInfoButtons(self)
    return unpackResults(results)
end)

MjsLua.hook("UI_HeadBtn.Reset", function(orig, self, showinfo, showemj, showchange)
    if
        DesktopMgr
        and DesktopMgr.Inst
        and GameUtility
        and GameUtility.EMJ_Mode
        and DesktopMgr.Inst.mode == GameUtility.EMJ_Mode.paipu
    then
        local results = pack(orig(self, showinfo, false, false))
        enablePaipuHeadInfo(self, self.localPos)
        return unpackResults(results)
    end

    return orig(self, showinfo, showemj, showchange)
end)

MjsLua.hook("UI_HeadBtn.OnChangeSeat", function(orig, self, showinfo, showemj, showchange)
    if
        DesktopMgr
        and DesktopMgr.Inst
        and GameUtility
        and GameUtility.EMJ_Mode
        and DesktopMgr.Inst.mode == GameUtility.EMJ_Mode.paipu
    then
        local results = pack(orig(self, showinfo, false, false))
        enablePaipuHeadInfo(self, self.localPos)
        return unpackResults(results)
    end

    return orig(self, showinfo, showemj, showchange)
end)

MjsLua.hook("UI_PlayerInfo.OnShow", function(orig, self, ...)
    local results = pack(orig(self, ...))
    setProfileAccountId(self)
    return unpackResults(results)
end)

MjsLua.hook("UI_PlayerInfo.RefreshNormalInfo", function(orig, self, ...)
    local results = pack(orig(self, ...))
    setProfileAccountId(self)
    return unpackResults(results)
end)

MjsLua.hook("UI_PlayerInfo.CopySelfID", function(orig, self, ...)
    if
        self
        and GameMgr
        and GameMgr.Inst
        and realAccountId(self.accountId)
        and self.accountId ~= GameMgr.Inst.account_id
    then
        copyProfileAccountId(self.accountId)
        return
    end

    return orig(self, ...)
end)

MjsLua.hook("UI_PlayerInfo.PageComment.Show", function(orig, self, ...)
    if not isPaipuReview() or not GameMgr or not GameMgr.Inst then
        return orig(self, ...)
    end

    local previousIngame = GameMgr.Inst.ingame
    GameMgr.Inst.ingame = false

    local results = pack(pcall(orig, self, ...))
    GameMgr.Inst.ingame = previousIngame

    if not results[1] then
        error(results[2], 0)
    end

    return unpack(results, 2, results.n)
end)

MjsLua.hook("UI_PlayerInfo.PageComment.RenderItem", function(orig, self, item, data)
    local results = pack(orig(self, item, data))

    if item and item.btnCheckInfo and realAccountId(item.accountId) then
        item.btnCheckInfo.gameObject:SetActive(true)
        item.btnCheckInfo.onClick:RemoveAllListeners()
        item.btnCheckInfo.onClick:AddListener(function()
            self:CheckInfo(item.accountId)
        end)
    end

    return unpackResults(results)
end)

MjsLua.hook("UI_PlayerInfo.PageComment.CheckInfo", function(orig, self, accountId)
    if not realAccountId(accountId) then
        return
    end

    UIMgr.Inst:ShowUI(
        UI_PlayerInfo.className,
        nil,
        { accountId = accountId, category = nil, tabType = nil, nameServiceType = nil }
    )
end)

log("loaded")
