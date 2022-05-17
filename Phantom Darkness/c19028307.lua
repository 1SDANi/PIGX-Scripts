--獣神機王バルバロスUr
--Beast Machine King Barbaros Ür
local s,id=GetID()
function s.initial_effect(c)
	--Type Dragon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(RACE_MACHINE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.atchk1,1,nil,sg)
end
function s.atchk1(c,sg)
	return c:IsRace(RACE_MACHINE) and sg:FilterCount(Card.IsRace,c,RACE_BEAST)==1
end
function s.spfilter1(c,rac)
	return c:IsRace(rac) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,RACE_MACHINE)
	local rg2=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,RACE_BEAST)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	if chk==0 then return #rg1>0 and #rg2>0 and aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,0) and
		Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,RACE_MACHINE+RACE_BEAST)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end