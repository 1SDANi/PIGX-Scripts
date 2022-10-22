--Everz Heliotrope
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(aux.IsGeminiState)
	e4:SetTarget(s.disable)
	c:RegisterEffect(e4)
end
function s.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT) and e:GetHandler()~=c
end