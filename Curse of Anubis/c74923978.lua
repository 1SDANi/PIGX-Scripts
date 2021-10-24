--強制接収
--Forced Requisition
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--Indes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCode(EVENT_DISCARD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.filter(c,tp)
	return c:IsPreviousControler(tp) and not c:IsReason(REASON_COST)
end
function s.cfilter(c,tp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil,e:GetHandler()) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.DiscardHand(p,aux.TRUE,p,p,REASON_EFFECT+REASON_DISCARD)
end
