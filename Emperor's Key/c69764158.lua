--ペロペロケルペロス
--Cerperuslobber
local s,id=GetID()
function s.initial_effect(c)
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(s.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetAttacker():IsControler(1-tp) or (Duel.GetAttackTarget() and Duel.GetAttackTarget():IsControler(1-tp))) and ep==tp
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker():GetControler()
	if a:IsControler(tp) and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsControler(1-tp) then a=Duel.GetAttackTarget() end
	Duel.Destroy(a,REASON_EFFECT)
end