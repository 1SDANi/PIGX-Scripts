--落とし大穴
--Dark Pitfall
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(s.filter,nil,tp,ep) end
	local g=eg:Filter(s.filter,nil,tp,ep)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	local tg2=tg:Filter(Card.IsRelateToEffect,nil,e)
	local g=tg2:Filter(s.filter,nil,tp,ep)
	if g and #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end