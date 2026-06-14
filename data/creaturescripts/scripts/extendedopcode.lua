local OPCODE_LANGUAGE = 1
local COINS_OPCODE = 52

function onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE_LANGUAGE then
		-- otclient language
		if buffer == 'en' or buffer == 'pt' then
			-- example, setting player language, because otclient is multi-language...
			-- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
		end
	elseif ( opcode == COINS_OPCODE ) then
	  if ( buffer == "requestCoin" ) then
		player:sendExtendedOpcode(opcode, tostring(player:getItemCount(24774)))  -- id do tibia coins 24774
	  end
	else
		-- other opcodes can be ignored, and the server will just work fine...
	end
end

function onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE_LANGUAGE then
		-- otclient language
		if buffer == 'en' or buffer == 'pt' then
			-- example, setting player language, because otclient is multi-language...
			-- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
		end
	elseif opcode == 215 then
		TaskSystem.onAction(player, json.decode(buffer))	
	else
		-- other opcodes can be ignored, and the server will just work fine...
	end
end