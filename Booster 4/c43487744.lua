--White Hole
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.cfilter,nil,e)>=2
end
function s.spfilter(c,e)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,0,c:GetControler(),false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(s.spfilter,nil,e)
		return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(s.spfilter,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.spfilter2(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsRelateToEffect(e) and
		c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,c:GetControler(),false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local sg1=eg:Filter(s.spfilter2,nil,e,tp)
	local sg2=eg:Filter(s.spfilter2,nil,e,1-tp)
	if ft<#sg1+#sg2 then return end
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(sg2,0,1-tp,1-tp,false,false,POS_FACEUP)
end