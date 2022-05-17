--デュアル・ランサー
--Gemini Lancer
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(aux.IsGeminiState)
	c:RegisterEffect(e1)
	--change base attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsGeminiState)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(3500)
	c:RegisterEffect(e2)
end
