--Red-Eyes Meteor Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3b),s.filter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_setcode={0x3b}
s.material_race={RACE_DRAGON}
s.material_attribute={ATTRIBUTE_FIRE}
function s.filter(c,fc,sumtype,tp)
	return (c:IsRace(RACE_DRAGON,fc,sumtype,tp) and (c:IsAttribute(ATTRIBUTE_FIRE,fc,sumtype,tp))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end