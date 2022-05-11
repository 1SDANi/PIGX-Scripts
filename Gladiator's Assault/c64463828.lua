--超合魔獣ラプテノス
--Superalloy Magical Dragon Raptinus
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsType,TYPE_GEMINI),2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--duel status
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_GEMINI))
	e1:SetCode(EFFECT_GEMINI_STATUS)
	c:RegisterEffect(e1)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end