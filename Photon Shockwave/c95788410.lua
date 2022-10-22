--Rabidragon
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(aux.IsGeminiState)
	e1:SetValue(s.aval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(s.dval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(aux.IsGeminiState)
	e3:SetValue(RACE_DRAGON)
	c:RegisterEffect(e3)
end
function s.aval(e,c)
	if c:IsType(TYPE_NORMAL+TYPE_GEMINI) then return 4000 else return 0 end
end
function s.dval(e,c)
	if c:IsType(TYPE_NORMAL+TYPE_GEMINI) then return 3500 else return 0 end
end