--ザ・キャリブレーター
--The Calibrator
local s,id=GetID()
function s.initial_effect(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function s.atkval(e,c)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(s.filter,c:GetControler(),0,LOCATION_MZONE,nil)
	return g1:GetSum(Card.GetLevel)*300 + g2:GetSum(Card.GetLevel)*300
end
