--ガスタの疾風 リーズ
--Gusto Shaman Sol
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c)
	return c:IsAbleToChangeControler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,2,nil) and
		Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g0=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g0,2,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_CONTROL)
	local tg1=g1:Filter(Card.IsRelateToEffect,nil,e)
	local tg2=g2:Filter(Card.IsRelateToEffect,nil,e)
	if tg1 and #tg1>0 and tg2 and #tg2==2 and Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT) then
		local a=tg2:GetFirst()
		local b=tg2:GetNext()
		Duel.SwapControl(a,b)
	end
end
