--不運なリポート
--An Unfortunate Report
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and Duel.GetTurnPlayer()==tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	Duel.PayLPCost(tp,Duel.GetLP(tp)-100)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.bpcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end