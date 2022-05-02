--異次元トンネル－ミラーゲート－
--Mirror Gate
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if chk==0 then return a:IsOnField() and a:IsAbleToChangeControler() and at:IsOnField() and at:IsAbleToChangeControler() and Duel.GetTurnPlayer()~=tp end
	local g=Group.FromCards(a,at)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if Duel.SwapControl(a,at,RESET_PHASE+PHASE_END,1) then
		Duel.CalculateDamage(a,at)
	end
end
