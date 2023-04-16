--アーティファクトの解放
--Artifacts Unleashed
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,s.ffilter))
end
function s.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end