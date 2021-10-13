--Metalzoa
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.filter1,s.filter2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.listed_names={46411259}
function s.filter1(c,fc,sumtype,tp)
	return c:IsRace(RACE_FIEND,fc,sumtype,tp) and c:GetLevel()>=7
end
function s.filter2(c,fc,sumtype,tp)
	return ((c:IsRace(RACE_MACHINE,fc,sumtype,tp) and c:IsType(TYPE_NORMAL)) or c:IsCode(68540058))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end