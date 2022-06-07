--Red-Eyes Black Metal Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,true,true,s.fusfilter,s.filter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.listed_names={CARD_METAMORPHOSIS}
s.material_setcode={0x3b}
s.material_race={RACE_MACHINE}
s.material_type={TYPE_NORMAL}
function s.fusfilter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.filter(c,fc,sumtype,tp)
	return ((c:IsRace(RACE_MACHINE,fc,sumtype,tp) and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER+TYPE_UNION)) or c:IsCode(68540058))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end