--暴君の暴力
--Tyrant's Tantrum
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end