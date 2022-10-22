--ジェムナイト・ジルコニア
--Gem-HERO Zirconia
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),s.fusfilter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_attribute={ATTRIBUTE_EARTH}
s.listed_series={0x08,0x34}
s.material_setcode={0x8,0x34}
function s.fusfilter(c)
	return c:IsSetCard(0x08) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end