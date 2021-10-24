--刻の封印
--Time Seal
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.hdcon)
	e1:SetTarget(s.hdtg)
	e1:SetOperation(s.hdop)
	if p==tp then 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,p)
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==ep and Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0
end
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,ep,1)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	if #g>0 then
		local sg=g:RandomSelect(ep,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end