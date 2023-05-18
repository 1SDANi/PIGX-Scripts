--バイバイダメージ
--Bye Bye Damage
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKDEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	return t and t:IsControler(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc and tc:IsRelateToBattle() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e3)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(3112)
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e5:SetValue(1)
		e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e5)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:GetFirst():IsRelateToBattle()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,ev*2,REASON_EFFECT)
end
