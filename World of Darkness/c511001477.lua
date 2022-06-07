--エース・オブ・ワンド
--Wand of Ace
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		local sg1=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.Destroy(sg1,REASON_EFFECT)
	elseif Duel.IsExistingMatchingCard(Duel.IsType,1-tp,LOCATION_HAND,0,1,nil,TYPE_SPELL) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) and
			Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) and Duel.DiscardHand(1-tp,Card.IsType,1,1,REASON_DISCARD,nil,TYPE_SPELL)>0 then
		local sg2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
		Duel.Destroy(sg2,REASON_EFFECT)
	end
end
