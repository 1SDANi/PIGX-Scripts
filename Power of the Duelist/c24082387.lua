--ミステリーサークル
--Crop Circles
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xc}
s.counter_list={COUNTER_A}
function s.sendfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetCounter(COUNTER_A)>0 and c:IsAbleToGrave() and
		Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK,1,nil,e,tp,c:GetLevel())
end
function s.filter(c,e,tp,lv)
	return c:IsSetCard(0xc) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsLevelBelow(lv)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.sendfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.sendfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),e,tp)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst():GetLevel())
		local tc=sg:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end