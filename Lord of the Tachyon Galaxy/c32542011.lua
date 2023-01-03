--燃え上がる大海
--Burning Ocean
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cfilter2(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.spfilter(c,tid,e,tp)
	local re=c:GetReasonEffect()
	return c:GetTurnID()==tid and c:IsReason(REASON_COST) and re and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER)
		and ft>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount(),e,tp)
	local b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local loc=b2 and LOCATION_MZONE or 0
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,loc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--WATER: Special Summon from the GY
	if Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	--FIRE: Destroy 1 monster on the field
	if Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_FIRE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
