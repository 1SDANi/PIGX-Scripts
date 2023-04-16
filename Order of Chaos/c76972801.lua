--ガガガガード
--Onomatoguard
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
s.listed_series={0x54,0x30a,0x82,0x59,0x8f}
function s.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x54) or c:IsSetCard(0x30a) or c:IsSetCard(0x82) or c:IsSetCard(0x59) or c:IsSetCard(0x8f))
end
function s.target(e,c)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,2,nil)
end
