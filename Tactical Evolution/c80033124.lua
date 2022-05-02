--サイバーダーク・インパクト！
--Cyberdark Impact!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0x4093),Card.IsAbleToDeck,s.fextra,Fusion.ShuffleMaterial)
	c:RegisterEffect(e1)
end
s.listed_series={0x4093}
function s.matfilter(c,lc,stype,tp)
	return c:IsCode(0x4093) and c:IsAbleToDeck()
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(aux.NecroValleyFilter(s.matfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
end
