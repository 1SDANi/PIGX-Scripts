--鉄壁の機皇兵
--Meklord Soldier Iron Wall
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTarget(s.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_series={0x13}
function s.target(e,c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x13)
end
