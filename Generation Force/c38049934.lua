--炎塵爆発
--Laval Explosion
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x39}
function s.csfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDiscardable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(s.csfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and g and #g>0 end
	Duel.DiscardHand(tp,s.csfilter,1,#g,REASON_COST+REASON_DISCARD)
	local og=Duel.GetOperatedGroup()
	local ct=#og
	e:SetLabel(ct)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#ct,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,e:GetHandler())
	if g and #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
