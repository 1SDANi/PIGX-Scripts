--アドバンス・フォース
--Advance Force
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,5))
	e1:SetValue(aux.TRUE)
	c:RegisterEffect(e1)
	--triple tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,7))
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
end
