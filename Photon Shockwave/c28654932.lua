--深黒の落とし穴
--Deep Dark Trap Hole
local s,id=GetID()
function s.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetLevel()>=5
		and (not e or c:IsRelateToEffect(e)) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:IsExists(s.filter,1,nil,nil) end
	local g=eg:Filter(s.filter,nil,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	local tg2=tg:Filter(Card.IsRelateToEffect,nil,e)
	local g=tg2:Filter(s.filter,nil,tp,ep)
	if g and #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
