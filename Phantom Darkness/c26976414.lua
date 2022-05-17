--Atlantean Pikeman
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.dircon)
	e2:SetTarget(aux.TRUE)
	c:RegisterEffect(e2)
end
function s.dircon(e)
	return Duel.IsEnvironment(CARD_UMI) and aux.IsGeminiState(e)
end
