--Perfectly Ultimate Great Moth
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,s.filter,40240595)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_race={RACE_INSECT}
s.listed_names={CARD_METAMORPHOSIS}
function s.filter(c,fc,sumtype,tp)
	return c:IsRace(RACE_INSECT,fc,sumtype,tp) and c:GetLevel()>=8
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end