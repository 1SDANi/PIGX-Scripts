--ハウスダストン
--House Duston
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Cannot be tributed
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(3303)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	--Cannot be used as fusion material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(3309)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
s.listed_series={0x80}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) end
	Duel.SetTargetPlayer(c:GetPreviousControler())
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,c:GetPreviousControler(),1000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0x80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0
		or #g1<=0 or #g2<=0 then return end
	local sg1
	local sg2
	local tc
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		sg1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		tc=sg1:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		sg2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		tc=sg2:GetFirst()
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
		g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	until not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and #g1>0 and #g2>0
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)))
end
