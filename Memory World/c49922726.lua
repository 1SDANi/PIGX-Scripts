--弓神レライエ
--Archer God Leraje
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.target)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)
end
function s.target(e,c)
	return c:IsAttribute(ATTRIBUTE_DIVINE)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_EFFECT)~=0
end