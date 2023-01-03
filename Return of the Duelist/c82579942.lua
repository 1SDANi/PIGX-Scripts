--ライトレイ マドール
--Lightray Madoor
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	aux.EnableGeminiAttribute(c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsGeminiState)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(2700)
	c:RegisterEffect(e1)
	--change base defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsGeminiState)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(3000)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetCondition(aux.IsGeminiState)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end