--同族感電ウィルス
--Tribe-Shocking Virus
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local att=0
	for tc in aux.Next(g) do
		att=(att|tc:GetRace())
	end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local aatt=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(aatt)
	local dg=g:Filter(Card.IsAttribute,nil,aatt)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function s.filter2(c,aatt)
	return c:IsFaceup() and c:IsAttribute(aatt)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local aatt=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,aatt)
	Duel.Destroy(g,REASON_EFFECT)
end
