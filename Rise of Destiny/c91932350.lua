--ハーピィ・レディ1
--Harpy Commander
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ALL)
	e1:SetValue(CARD_HARPY_LADY)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(s.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function s.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end