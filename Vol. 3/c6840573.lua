--Barox
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FIEND),aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_race={RACE_FIEND,RACE_BEAST}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end