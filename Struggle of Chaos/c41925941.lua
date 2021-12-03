--冥王の咆哮
--Bark of Dark Ruler
local s,id=GetID()
function s.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(tp) then 
		e:SetLabelObject(d)
		return a:IsFaceup() and a:IsRace(RACE_FIEND) and a:IsRelateToBattle()
			and d and d:IsFaceup() and d:IsRelateToBattle()
	elseif d and d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsFaceup() and d:IsRace(RACE_FIEND) and d:IsRelateToBattle()
			and a and a:IsFaceup() and a:IsRelateToBattle()
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc==tc end
	local a=Duel.GetAttacker()
	if tc==a then a=Duel.GetAttackTarget() end
	if chk==0 then return (tc:IsAttackAbove(100) or tc:IsDefenseAbove(100)) and 
		a:IsAttackAbove(100) and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetFirstTarget()
	if not bc or not bc:IsRelateToEffect(e) or not bc:IsControler(1-tp) then return end
	local a=Duel.GetAttacker()
	if bc==a then a=Duel.GetAttackTarget() end
	local val=a:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	bc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	bc:RegisterEffect(e2)
end
