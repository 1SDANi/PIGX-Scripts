--ナチュル・ドラゴンフライ
--Naturia Dragonfly
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.target)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)
end
s.listed_series={0x2a}
function s.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x2a)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end