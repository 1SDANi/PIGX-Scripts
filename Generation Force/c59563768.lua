--転身テンシーン
--Angle Angel
local s,id=GetID()
function s.initial_effect(c)
	--atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e3)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsLevelBelow,3),c:GetControler(),LOCATION_MZONE,0,c)*1000
end