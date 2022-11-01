--マスター・オブ・OZ
--Master of Oz
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST),1,aux.AND(aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST),aux.FilterBoolFunctionEx(Card.IsLevelAbove,5)))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_race={RACE_BEAST}
s.listed_names={CARD_METAMORPHOSIS}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end