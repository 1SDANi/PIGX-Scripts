--急転直下
--Out of the Blue
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.cn)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and eg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end