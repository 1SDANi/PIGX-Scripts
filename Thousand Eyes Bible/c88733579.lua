--穿孔虫
--Drill Bug
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={27911549}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if (r&REASON_EFFECT)~=0 then return false end
	return e:GetHandler():IsRelateToBattle()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,27911549):GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(tc,1-tp,0,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_DECK) then return end
		tc:ReverseInDeck()
	end
end