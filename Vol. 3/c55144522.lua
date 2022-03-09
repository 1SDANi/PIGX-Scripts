--強欲な壺
--Pot of Greed
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.IsExistingMatchingCard(Duel.IsType,1-p,LOCATION_HAND,0,1,nil,TYPE_SPELL) and Duel.IsPlayerCanDraw(1-p,2) and
		Duel.SelectYesNo(1-p,aux.Stringid(id,1)) and
			Duel.DiscardHand(1-p,Card.IsType,1,1,REASON_DISCARD,nil,TYPE_SPELL)>0 then
		Duel.Draw(1-p,d,REASON_EFFECT)
	else
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
