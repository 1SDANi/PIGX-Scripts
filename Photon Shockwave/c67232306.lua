--聖なる鎧 －ミラーメール－
--Mirror Mail
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKDEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetAttackTarget()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=eg:GetFirst()
	local a=Duel.GetAttacker()
	if chk==0 then return at:IsControler(tp) and at:IsOnField() and at:IsFaceup() and a:IsOnField() end
	at:CreateEffectRelation(e)
	a:CreateEffectRelation(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local at=eg:GetFirst()
	local a=Duel.GetAttacker()
	if not a:IsRelateToEffect(e) or not at:IsRelateToEffect(e) or a:IsFacedown() or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(a:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	at:RegisterEffect(e1)
end
