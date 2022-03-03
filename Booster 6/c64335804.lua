--Red-Eyes Black Metal Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3b),s.filter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.listed_names={CARD_METAMORPHOSIS}
s.material_setcode={0x3b}
s.material_race={RACE_MACHINE}
s.material_type={TYPE_NORMAL}
function s.filter(c,fc,sumtype,tp)
	return (c:IsRace(RACE_MACHINE,fc,sumtype,tp) and c:IsType(TYPE_NORMAL) or c:IsCode(68540058))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end