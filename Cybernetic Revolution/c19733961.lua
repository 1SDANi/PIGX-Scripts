--電池メン－単二型
--Batteryman C
local s,id=GetID()
function s.initial_effect(c)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.tg)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
s.listed_series={0x28}
function s.tg(c)
	return c:IsRace(RACE_MACHINE) or c:IsSetCard(0x28)
end
function s.val(e,c)
	return Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsSetCard,0x28),c:GetControler(),LOCATION_MZONE,0,nil)*500
end