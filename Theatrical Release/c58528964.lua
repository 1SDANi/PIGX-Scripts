--Ifrit
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	--Fusion summon procedure
	Fusion.AddProcMix(c,false,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),aux.FilterBoolFunctionEx(Card.IsRace,RACE_ZOMBIE))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_race={RACE_ZOMBIE}
s.material_attribute={ATTRIBUTE_FIRE}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end