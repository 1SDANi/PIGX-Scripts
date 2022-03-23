--森の番人グリーン・バブーン
--Green Baboon, Defender of the Forest
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.spcn)
	e1:SetCost(s.spcs)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp) and
		c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST)
end
function s.spcn(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.filter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5) and c:IsRace(RACE_BEAST) and c:IsFaceup()
end
function s.spcs(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.filter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.filter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
