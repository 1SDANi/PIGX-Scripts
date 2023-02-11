--強欲で謙虚な壺
--Pot of Duality
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(55144522)
	c:RegisterEffect(e0)
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
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(Duel.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_TRAP) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsType,1,1,REASON_DISCARD,nil,TYPE_TRAP)>0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(Duel.IsType,1-tp,LOCATION_HAND,0,1,nil,TYPE_SPELL) and Duel.IsPlayerCanDraw(1-tp,2) and
		Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) and Duel.DiscardHand(1-tp,Card.IsType,1,1,REASON_DISCARD,nil,TYPE_SPELL)>0 then
		Duel.Draw(1-tp,2,REASON_EFFECT)
	end
end
