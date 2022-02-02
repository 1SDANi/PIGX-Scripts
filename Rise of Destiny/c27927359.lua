--ハーピィ・レディ2
--Harpy Assassin
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
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_HARPIE_LADY}
function s.disable(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_FLIP) or 
	((c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT and (c:GetOriginalType()&TYPE_FLIP)==TYPE_FLIP)
end