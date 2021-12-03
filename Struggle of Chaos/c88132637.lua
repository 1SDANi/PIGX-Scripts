--ツインヘッド・ケルベロス
local s,id=GetID()
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
end
function s.disable(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_FLIP) or 
	((c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT and (c:GetOriginalType()&TYPE_FLIP)==TYPE_FLIP)
end