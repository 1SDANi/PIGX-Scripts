--飛行エレファント
--Flying Elephant
local s,id=GetID()
function s.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.dircon)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFacedown() or not c:IsLevelAbove(5)
end
function s.dircon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil)
end
