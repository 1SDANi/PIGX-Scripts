--進化する翼
--Transcendent Wings
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,s.ffilter))
end
function s.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end