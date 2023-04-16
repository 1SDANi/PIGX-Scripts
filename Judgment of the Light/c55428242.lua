--アトラの蟲惑魔
--Traptrix Atrax
local s,id=GetID()
function s.initial_effect(c)
	--immune trap
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(s.efilter)
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
	return te:IsActiveType(TYPE_TRAP) and te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end