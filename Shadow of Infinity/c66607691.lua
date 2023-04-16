--フォトン・ジェネレーター・ユニット
--Photon Generator Unit
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,s.ffilter))
end
function s.ffilter(c)
	return c:IsRace(RACE_MACHINE)
end