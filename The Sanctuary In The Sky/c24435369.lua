--マーメイド・ナイト
--Atlantean Knight
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(s.dircon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_UMI}
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_UMI)
end
function s.dircon(e)
	return (Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(CARD_UMI))
end
