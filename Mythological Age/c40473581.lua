--雷帝神
--Susano-o
local s,id=GetID()
function s.initial_effect(c)
	--Spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
end
