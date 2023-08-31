--星守る結界
--Hexatellarknight
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.val(e,c)
	return c:GetCounter(COUNTER_XYZ)*200
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetAttacker():GetControler()
	if Duel.IsCanRemoveCounter(1-p,1,0,COUNTER_XYZ,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) and Duel.RemoveCounter(1-p,1,0,COUNTER_XYZ,1,REASON_EFFECT) then
		Duel.NegateAttack()
	end
end