--D・ラジカッセン
--Deformer Boombon
local s,id=GetID()
function s.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(s.cona)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.target)
	e2:SetValue(s.valcon)
	c:RegisterEffect(e2)
end
s.listed_series={0x26}
function s.cona(e)
	return e:GetHandler():IsAttackPos()
end
function s.target(e,c)
	return e:GetHandler()~=c
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end