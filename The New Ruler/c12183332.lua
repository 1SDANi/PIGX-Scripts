--ショット・ガン・シャッフル
--Shotgun Shuffle
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.cfcon)
	e3:SetTarget(s.cftg)
	e3:SetOperation(s.cfop)
	c:RegisterEffect(e3)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if opt==0 then 
		Duel.ShuffleDeck(tp)
	else
		Duel.ShuffleDeck(1-tp)
	end
end
function s.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function s.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g2)
	Duel.ConfirmCards(tp,g1)
	Duel.ShuffleHand(1-tp)
end
