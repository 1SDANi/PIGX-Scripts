--ロストガーディアン
--Lost Guardian
local s,id=GetID()
function s.initial_effect(c)
	--Attack while in defense position
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DEFENSE_ATTACK)
	e0:SetValue(0)
	c:RegisterEffect(e0)
	--change defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.defval)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.defval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_REMOVED,0,nil)*1000
end
