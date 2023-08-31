--希望の創造者
--ZEXAL
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,#g,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#g,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,#g,tp,LOCATION_HAND)
end
function s.filter(c)
	return (c:IsSetCard(0x7f) or c:IsSetCard(0x7e)) and c:IsAbleToHand()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,#g,nil) then return end
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #g==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(p)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,#g,#g,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
