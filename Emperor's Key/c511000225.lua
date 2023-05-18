--ＲＤＭ－ホープ・フォール
--Rank-Down-Magic Hope Fall
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x7f}
s.counter_place_list={COUNTER_XYZ}
function s.filter(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x7f) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and not c:IsLevelAbove(lv)
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x7f) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and
		c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and #eg==1 and eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if eg and #eg==1 and eg:GetFirst() then
		local lv=eg:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP) then
			tc:AddCounter(COUNTER_XYZ,1)
		end
	end
end