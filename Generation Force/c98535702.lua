--ダメージ・ワクチンΩMAX
--Damage Vaccine Ω MAX
local s,id=GetID()
function s.initial_effect(c)
	--reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,8000)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,8000,REASON_EFFECT)
end
