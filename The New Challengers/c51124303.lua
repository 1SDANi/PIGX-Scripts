--影霊衣の万華鏡
--Nekroz Kaliedoscope
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
s.listed_series={0xb4}
function s.mfilter1(c)
	return c:HasLevel() and c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER)
end
function s.mfilter2(c)
	return c:IsAbleToRemove() and not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741)
end
function s.rfilter(c,e,tp)
	return s.mfilter1(c) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and not c:IsHasEffect(EFFECT_SPSUMMON_CONDITION)
end
function s.filter(c,e,tp)
	local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND,0,c,e,tp)
	return g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
end
function s.lvfilter(c,e,tp,g,tc)
	return g:CheckWithSumEqual(Card.GetLevel,tc:GetLevel(),1,99)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,nil)
		return mg1:Merge(mg2):IsExists(s.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=mg1:Merge(mg2):Filter(s.filter,nil,e,tp):Select(tp,1,1,nil)
	if #tg>0 then
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local mat=g:Filter(s.lvfilter,tc,e,tp,g,tc):SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,99)
		local mt=mat:GetFirst()
		for mt in aux.Next(mat) do
			mt:SetMaterial(tc)
		end
		if tc:IsLocation(LOCATION_GRAVE) then
			Duel.Remove(Group.FromCards(tc),POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		else
			Duel.ReleaseRitualMaterial(Group.FromCards(tc))
		end
		Duel.BreakEffect()
		mt=mat:GetFirst()
		for mt in aux.Next(mat) do
			Duel.SpecialSummon(Group.FromCards(mt),SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
			mt:CompleteProcedure()
		end
	end
end