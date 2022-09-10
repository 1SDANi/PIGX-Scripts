--ハーモニック・ジオグリフ
--Harmonic Geoglyph
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={83994433,33698022,4179255,68084557,60992105,39765958,26268488}
function s.filter1(c)
	return c:IsFaceup() and c:IsCode(83994433)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.filter1,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.filter1,1,1,false,nil,nil)
	Duel.Release(sg,REASON_COST)
end
function s.filter3(c)
	return c:IsCode(33698022,4179255,68084557,60992105,39765958) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return g and g:GetClassCount(Card.GetCode)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,5,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCode(26268488) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if #g==0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,5,5,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
		local sc=Duel.GetFirstMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end