--ハイパー・ギャラクシー
--Hyper Galaxy
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_GALAXYEYES_P_DRAGON}
function s.filter(c)
	return c:IsReleasable() and c:IsAttackAbove(2000)
end
function s.spcheck(sg,e,tp,mg)
	return Duel.GetMZoneCount(1-tp,sg,tp)>0 and aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.atchk1,1,nil,sg,tp)
end
function s.atchk1(c,sg,tp)
	return c:IsControler(tp) and sg:FilterCount(Card.IsControler,c,1-tp)==1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return aux.SelectUnselectGroup(mg,e,tp,2,2,s.spcheck,0) end
	local g=aux.SelectUnselectGroup(mg,e,tp,2,2,s.spcheck,1,tp,HINTMSG_RELEASE,nil,nil,false)
	Duel.Release(g,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsCode(CARD_GALAXYEYES_P_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end