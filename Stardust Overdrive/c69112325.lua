--神聖なる森
--Spiritual Forest
local s,id=GetID()
function s.initial_effect(c)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.tg)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end
function s.tg(e,c)
	if e:GetHandler():GetFlagEffect(id+c:GetControler())~=0 then
		return false
	end
	if c:IsRace(RACE_BEAST+RACE_INSECT+RACE_PLANT) then
		e:GetHandler():RegisterFlagEffect(id+c:GetControler(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	end
end