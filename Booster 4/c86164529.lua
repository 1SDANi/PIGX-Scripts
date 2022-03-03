--アクア・ドラゴン
--Aqua Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_REDEYES_B_DRAGON,aux.AND(aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER)))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.listed_names={CARD_REDEYES_B_DRAGON}
s.material_race={RACE_DRAGON}
s.material_attribute={ATTRIBUTE_WATER}
s.material_setcode=0x3b
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end