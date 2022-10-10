--ガスタの巫女 ウィンダ
--Gusto Priestess Wyn
local s,id=GetID()
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter1(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local tg1=g1:Filter(Card.IsRelateToEffect,nil,e)
	local tg2=g2:Filter(Card.IsRelateToEffect,nil,e)
	if tg1 and #tg1>0 and tg2 and #tg2>0 and Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT) then
		Duel.SendtoHand(tg2,nil,REASON_EFFECT)
	end
end