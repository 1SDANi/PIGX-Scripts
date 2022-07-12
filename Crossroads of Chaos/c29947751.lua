--D・マグネンU
--Morphtronic Magnen
local s,id=GetID()
function s.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetCondition(s.dircon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e2:SetCondition(s.cond)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.dircon(e)
	return e:GetHandler():IsAttackPos()
end
function s.cond(e)
	return e:GetHandler():IsDefensePos()
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end