--幻影融合
--Vision Fusion
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,aux.TRUE,aux.TRUE,s.fextra))
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_SZONE,0,nil,TYPE_MONSTER+TYPE_UNION)
end