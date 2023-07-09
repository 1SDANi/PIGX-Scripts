--海皇の竜騎隊
--Atlantean Dragoons
local s,id=GetID()
function s.initial_effect(c)
	--direct attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetCondition(s.dircon)
	e0:SetTarget(aux.TRUE)
	c:RegisterEffect(e0)
end
s.listed_names={CARD_UMI}
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_UMI)
end
function s.dircon(e)
	return (Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(CARD_UMI))
end
