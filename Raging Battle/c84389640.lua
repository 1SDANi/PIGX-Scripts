--窮鼠の進撃
--Attack of the Cornered Rat
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.tg)
	e2:SetValue(3000)
	c:RegisterEffect(e2)
end
function s.tg(e,c)
	return (c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_DECK))) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(3)
end