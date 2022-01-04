--鉄の騎士 ギア・フリード
--Gearfried the Iron Knight
local s,id=GetID()
function s.initial_effect(c)
	--destroy equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_EQUIP)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.filter(c,ec)
	return c:GetEquipTarget()==ec
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,e:GetHandler()) end
	local dg=eg:Filter(s.filter,nil,e:GetHandler())
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if Duel.Destroy(tg,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) and
			Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and
			Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)>0 then
			local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
