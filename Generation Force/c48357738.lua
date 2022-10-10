--暴君の暴飲暴食
--Tyrant's Tummyache
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.sumlimit)
	c:RegisterEffect(e2)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsMonster() then
		return c:IsType(TYPE_EFFECT)
	else
		return c:IsOriginalType(TYPE_EFFECT)
	end
end
