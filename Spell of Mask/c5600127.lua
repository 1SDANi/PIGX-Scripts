--ヒューマノイド・ドレイク
--Slime Drake
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_REPTILE),s.filter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_race={RACE_REPTILE+RACE_ELEMENTAL}
s.material_attribute={ATTRIBUTE_WATER}
function s.filter(c,fc,sumtype,tp)
	return (c:IsRace(RACE_ELEMENTAL,fc,sumtype,tp) and (c:IsAttribute(ATTRIBUTE_WATER,fc,sumtype,tp)))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end