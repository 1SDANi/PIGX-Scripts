--煉獄の釜 
--Void Cauldron
local s,id=GetID()
function s.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TRUE)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
end
function s.value(e)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0 then
		return 1
	else
		return 0
	end
end