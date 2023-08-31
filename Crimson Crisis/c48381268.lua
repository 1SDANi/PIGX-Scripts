--D・ボードン
--Morphtronic Skateboarden
local s,id=GetID()
function s.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.cona)
	e1:SetTarget(aux.TRUE)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.cond)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.cona(e)
	return e:GetHandler():IsAttackPos()
end
function s.cond(e)
	return e:GetHandler():IsDefensePos()
end
function s.efilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandler():GetControler() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
