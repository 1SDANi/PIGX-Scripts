--アーティファクトの解放
--Artifacts Unleashed
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,aux.TRUE,aux.FALSE,s.fextra))
end
function s.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_SZONE,0,nil,TYPE_MONSTER+TYPE_UNION)
end