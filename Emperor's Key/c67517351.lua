--HRUM-ユートピア・フォース
--Hyper-Rank-Up-Magic Hope Force
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f}
function s.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x7f) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and (c:IsLevel(lv+1) or c:IsLevel(lv+2))
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x7f) and c:IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_COST) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and tc:IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_COST) then
		local n=1
		if tc:IsCanRemoveCounter(tp,COUNTER_XYZ,2,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) and
			Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp,tc:GetLevel()) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1 then
			n=2
		end
		tc:RemoveCounter(tp,COUNTER_XYZ,n,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,n,n,nil,e,tp,tc:GetLevel())
		if g and #g>0 then
			local sc=g:GetFirst()
			for sc in aux.Next(g) do
				if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
					sc:CompleteProcedure()
					if sc:IsCanAddCounter(COUNTER_XYZ,1) then
						sc:AddCounter(COUNTER_XYZ,1)
					end
				end
			end
		end
	end
end