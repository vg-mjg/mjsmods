local function log(msg)
    MjsLua.log("[precise_friend_times] " .. msg)
end

local function preciseTime(unixTime)
	local timestamp = tonumber(unixTime)
	if timestamp == nil or timestamp <= 0 then
		return nil
	end

	local ok, formatted = pcall(os.date, "%Y-%m-%d %H:%M", timestamp)
	if ok and formatted then
		return formatted
	end

	return nil
end

local function applyFriendListStateText(textComponent, friend)
	if textComponent == nil or friend == nil or friend.state == nil or friend.state.is_online then
		return
	end

	local formatted = preciseTime(friend.state.logout_time)
	if formatted == nil then
		return
	end

	textComponent.text = formatted
end

local function applyApplicationTimeText(textComponent, application)
	if textComponent == nil or application == nil then
		return
	end

	local formatted = preciseTime(application.apply_time)
	if formatted then
		textComponent.text = formatted
	end
end

MjsLua.hook("UI_Friend.PageFriend.RenderItem", function(orig, self, row, context)
	local results = { orig(self, row, context) }

	local friend = nil
	if self and self.sortlist and row and row.dataIndex and FriendMgr and FriendMgr.Inst then
		local sourceIndex = self.sortlist[row.dataIndex]
		if sourceIndex and FriendMgr.Inst._friend_list then
			friend = FriendMgr.Inst._friend_list[sourceIndex]
		end
	end

	if row and row.builtUI then
		applyFriendListStateText(row.builtUI.state, friend)
	end

	return unpack(results)
end)

MjsLua.hook("UI_Friend.PageFriend.UpdateItem", function(orig, self, item, index)
	local results = { orig(self, item, index) }

	local friend = nil
	if self and self.sortlist and index and FriendMgr and FriendMgr.Inst then
		local sourceIndex = self.sortlist[index]
		if sourceIndex and FriendMgr.Inst._friend_list then
			friend = FriendMgr.Inst._friend_list[sourceIndex]
		end
	end

	if item and friend then
		local state = item.transform:Find("state"):GetComponent(typeof(UnityEngine.UI.Text))
		applyFriendListStateText(state, friend)
	end

	return unpack(results)
end)

MjsLua.hook("UI_Friend.PageApply.UpdateItem", function(orig, self, item, index)
	local results = { orig(self, item, index) }

	local application = nil
	if self and self.playerinfos_loaded and index then
		application = self.playerinfos_loaded[index]
	end

	if item and application then
		local state = item.transform:Find("state"):GetComponent(typeof(UnityEngine.UI.Text))
		applyApplicationTimeText(state, application)
	end

	return unpack(results)
end)

log("loaded")
