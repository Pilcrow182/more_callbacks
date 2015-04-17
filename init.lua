more_callbacks = {}
more_callbacks.on_hp_change = {}
more_callbacks.register_on_hp_change = function(def)
	table.insert(more_callbacks.on_hp_change, def)
end

local players = {}
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local health = player:get_hp()

		if players[name] then
			local change = health - players[name].oldhealth
			if change ~= 0 then
				for _,exec_func in ipairs(more_callbacks.on_hp_change) do
					exec_func(player, change)
				end
			end
		else
			players[name] = {}
		end

		players[name].oldhealth = health
	end
end)


-- example usage:
more_callbacks.register_on_hp_change(function(player, change)
	if change > 0 then
		minetest.chat_send_player(player:get_player_name(), "You just got healed by "..change.." HP!")
	else
		minetest.chat_send_player(player:get_player_name(), "You just got damaged by "..math.abs(change).." HP!")
	end
end)
