--マシュマロンのメガネ
--Marshmallon Glasses
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	e2:SetCondition(s.cn)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(s.atklimit)
	c:RegisterEffect(e3)
end
s.listed_names={31305911}
function s.atklimit(e,c)
	return c:IsCode(31305911)
end
function s.cn(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,31305911),e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end