--鉄壁の布陣
--Impenetrable Formation
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.TRUE,c:GetControler(),LOCATION_MZONE,0,nil)*500
end