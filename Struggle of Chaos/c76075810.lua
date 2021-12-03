--投石部隊
--Catapult
local s,id=GetID()
function s.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.descost)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.desfilter(c,def)
	return c:IsFaceup() and c:IsDefenseBelow(def)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c:GetDefense())
	if chk==0 then return dg>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg-g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local def=c:GetDefense()
	if not c:IsRelateToEffect(e) then def=c:GetPreviousDefenseOnField() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,def)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
