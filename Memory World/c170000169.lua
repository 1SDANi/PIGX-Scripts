--Orichalcos Aristeros
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot be destroyed by battle or card effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3008)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.atcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(s.defcon)
	e3:SetOperation(s.defop)
	c:RegisterEffect(e3)
end
s.listed_names={7634581}
function s.defcon(e)
	return e:GetHandler():GetBattleTarget() and Duel.IsExistingMatchingCard(s.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.atfilter,tp,LOCATION_MZONE,0,1,nil)
	if not g then return end
	local c=e:GetHandler()
	local b=Duel.GetAttacker()
	if b==c then b=Duel.GetAttackTarget() end
	local value=b:GetAttack()
	if value<b:GetDefense() then value=b:GetDefense() end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(value)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		c:RegisterEffect(e2)
		Duel.BreakEffect()
		if g then
			for tc in aux.Next(g) do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(-value)
				c:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e4)
			end
		end
	end
end
function s.atfilter(c)
	return c:IsFaceup() and c:IsCode(7634581)
end
function s.atcon(e)
	return Duel.IsExistingMatchingCard(s.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end