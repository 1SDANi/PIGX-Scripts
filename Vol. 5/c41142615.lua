--陽気な葬儀屋
--The Cheerful Undertaker
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local i=Duel.DiscardHand(tp,aux.TRUE,1,math.min(2,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)),REASON_EFFECT+REASON_DISCARD)
	if i>0 then
		Duel.DiscardHand(1-tp,aux.TRUE,i,i,REASON_EFFECT+REASON_DISCARD)
	end
end
