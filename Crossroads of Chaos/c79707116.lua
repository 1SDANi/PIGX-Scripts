--パラライズ・チェーン
--Paralyzing Chain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_DECK
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	return (r&REASON_EFFECT)~=0 and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(s.cfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,ct,PLAYER_ALL,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local ct=eg:FilterCount(s.cfilter,nil)
	Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end