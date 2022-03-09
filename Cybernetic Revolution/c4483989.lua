--はんげきじゅんび
--Counterattack
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetTarget(s.atktg1)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg2)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return tp~=Duel.GetTurnPlayer() and at and at:IsPosition(POS_DEFENSE)
end
function s.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local at=Duel.GetAttackTarget()
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer()
		and at and at:IsPosition(POS_DEFENSE) then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,at,1,0,0)
	end
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,at,1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if at then Duel.ChangePosition(at,POS_FACEUP_ATTACK) end
end
