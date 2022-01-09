--ケルドウ
--Keldo
local s,id=GetID()
function s.initial_effect(c)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	if not g then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
