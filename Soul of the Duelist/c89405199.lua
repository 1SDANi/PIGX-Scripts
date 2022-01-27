--グリード
--Greed
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (eg:IsExists(s.cfilter,1,nil,1-tp) or eg:IsExists(s.cfilter,1,nil,tp)) and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct1=eg:FilterCount(s.cfilter,nil,1-tp)
	local ct1=eg:FilterCount(s.cfilter,nil,tp)
	
	if ct1 and ct2 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	elseif ct1 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct1*1000)
	elseif ct2 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct2*1000)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct1=eg:FilterCount(s.cfilter,nil,1-tp)
	local ct1=eg:FilterCount(s.cfilter,nil,tp)
	if ct1 then Duel.Damage(tp,ct1*1000,REASON_EFFECT,true) end
	if ct2 then Duel.Damage(1-tp,ct2*1000,REASON_EFFECT,true) end
	Duel.RDComplete()
end
