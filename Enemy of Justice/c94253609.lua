--エレメンタル・アブソーバー
--Elemental Absorber
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.filter)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function s.filter(e,c)
	return (c:GetAttribute()&(e:GetLabelObject():GetLabel()))~=0
end
function s.rmfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_ALL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and
		Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND,0,1,nil,tp,POS_FACEUP) end
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		e:SetLabel(e:GetLabel()+g:GetFirst():GetAttribute())
		Duel.BreakEffect()
		if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.GetAttacker() and
			(c:GetAttribute()&(GetLabel()))~=0 then
			Duel.NegateAttack()
		end
	end
end