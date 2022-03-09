--ホーリージャベリン
--Holy Javelin
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsOnField() end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,Duel.GetAttacker():GetAttack())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,Duel.GetAttacker():GetAttack(),REASON_EFFECT)
end
