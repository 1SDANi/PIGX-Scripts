--コンフュージョン・チャフ
--Confusion Chaff
local s,id=GetID()
function s.initial_effect(c)
	--damage cal
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:GetAttackedCount()>0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetActivityCount(tp,ACTIVITY_ATTACK)>=0 and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local sc=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if sc and a:CanAttack() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,sc:GetFirst())
	end
end
