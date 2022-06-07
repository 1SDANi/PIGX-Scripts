--Ｄ－フォース
--D - Force
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetCondition(s.condition)
	c:RegisterEffect(e2)
	--Cannot draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(aux.AND(s.condition,s.drawcon))
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.condition)
	e4:SetValue(0)
	c:RegisterEffect(e4)
end
s.listed_series={0x3008}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3008) and c:IsLevelAbove(7)
end
function s.condition(e)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.drawcon(e)
	return Duel.GetCurrentPhase()==PHASE_DRAW
end