--天狗のうちわ
--Tengu Fan
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function s.disable(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_FLIP) or 
	((c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT and (c:GetOriginalType()&TYPE_FLIP)==TYPE_FLIP)
end