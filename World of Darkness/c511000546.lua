--エース・オブ・ソード
--Ace of Sword
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
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		local sg1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
		Duel.Destroy(sg1,REASON_EFFECT)
	elseif Duel.IsExistingMatchingCard(Duel.IsType,1-tp,LOCATION_HAND,0,1,nil,TYPE_SPELL) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and
			Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) and Duel.DiscardHand(1-tp,Card.IsType,1,1,REASON_DISCARD,nil,TYPE_SPELL)>0 then
		local sg2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
		Duel.Destroy(sg2,REASON_EFFECT)
	end
end
