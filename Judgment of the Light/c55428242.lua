--アトラの蟲惑魔
--Traptrix Atrax
local s,id=GetID()
function s.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--Can activate "Hole" Normal Traps from your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(s.efilter)
	c:RegisterEffect(e2)
end
s.listed_series={0x4c}
function s.efilter(e,te)
	return te:GetHandler():IsType(TYPE_TRAP) and te:GetHandler():IsSetCard(0x4c)
end