--インヴェルズの歩哨
--Inverz Sentinel
local s,id=GetID()
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(s.distg)
	c:RegisterEffect(e1)
end
function s.distg(e,c)
	return c:GetLevel()>=5 and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
