--表裏一体
--Duality
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 LIGHT monster with the same Type and Level from the Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.spcs)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:HasLevel() and c:IsType(TYPE_LEVEL)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function s.spfilter(c,e,tp,lvl,race,attribute)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:GetLevel()==lvl and c:IsRace(race)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsAttribute(attribute)
end
function s.spcs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.tgfilter,1,false,nil,nil,e,tp) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.tgfilter,1,1,false,nil,nil,e,tp)
	e:SetLabel(sg:GetFirst():GetLevel(),sg:GetFirst():GetRace(),sg:GetFirst():GetAttribute())
	Duel.Release(sg,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv,rc,at=e:GetLevel()
	if not (lv and rc and at) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,rc,at)
	if #g>0 then
		Duel.SpecialSummonStep(g,0,tp,tp,false,false,POS_FACEUP)
	end
end