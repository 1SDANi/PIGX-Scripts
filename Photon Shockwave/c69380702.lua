--Bunilla
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(aux.IsGeminiState)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function s.val(e,c)
	if c:IsType(TYPE_NORMAL+TYPE_GEMINI) then
		return Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsType,TYPE_NORMAL+TYPE_GEMINI),c:GetControler(),LOCATION_MZONE,0,nil)*1000
	else
		return 0
	end
end