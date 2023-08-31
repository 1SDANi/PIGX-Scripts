--ヘルホーンドザウルス
--Horned Saurus
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixN(c,false,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_REPTILE),2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
s.material_race={RACE_REPTILE}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end