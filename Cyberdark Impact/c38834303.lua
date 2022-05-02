--カウンタークリーナー
--Counter Cleaner
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.HasCounters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	for tc in Duel.GetMatchingGroup(Card.HasCounters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Iter() do
		tc:RemoveAllCounters()
	end
end
