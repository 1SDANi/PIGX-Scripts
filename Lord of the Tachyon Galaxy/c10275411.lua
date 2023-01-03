--エクシーズ・リベンジ
--Xyz Revenge
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg and #sg==2 then
		local g1=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local g2=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP) then
			if g2:GetFirst():IsCanAddCounter(COUNTER_XYZ,1) and
				g1:GetFirst():GetOverlayCount()>0 and
				g1:GetFirst():IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_EFFECT) and
				g1:GetFirst():RemoveCounter(tp,COUNTER_SPELL,1,REASON_EFFECT)>0 then
				g2:GetFirst():AddCounter(COUNTER_XYZ,2)
			end
		end
	end
end