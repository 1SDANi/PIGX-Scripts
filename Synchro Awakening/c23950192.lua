--氷結界の術者
--Cryomancer of the Ice Barrier
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
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x2f),e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler()) and
		aux.IsGeminiState(e)
end