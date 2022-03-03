--レジェンド・オブ・ハート
--Legend of Heart
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetProperty(EFFECT_FLAG_DELAY)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetProperty(EFFECT_FLAG_DELAY)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(s.checkop3)
		Duel.RegisterEffect(ge3,0)
	end)
end
s.listed_names={11082056,1784686,46232525,84565800,80019195,85800949}
--Critias
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	 if rp==e:GetHandlerPlayer() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsCode(11082056) then
		Duel.RegisterFlagEffect(rp,id,0,0,1)
	end
end
--Timaeus
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	 if rp==e:GetHandlerPlayer() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsCode(1784686) then
		Duel.RegisterFlagEffect(rp,id+1,0,0,1)
	end
end
--Hermos
function s.checkop3(e,tp,eg,ep,ev,re,r,rp)
	 if rp==e:GetHandlerPlayer() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsCode(46232525) then
		Duel.RegisterFlagEffect(rp,id+2,0,0,1)
	end
end
function s.cfilter(c,ft,tp)
	return c:IsRace(RACE_WARRIOR) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and (c:IsFaceup() or c:IsControler(tp))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,ft,tp,84565800,2)
	Duel.Release(sg,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and
		((c:IsCode(84565800) and Duel.GetFlagEffect(tp,id+2)~=0) or
		(c:IsCode(80019195) and Duel.GetFlagEffect(tp,id+1)~=0) or
		(c:IsCode(85800949) and Duel.GetFlagEffect(tp,id)~=0))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RITUAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end
	local ct=g:GetClassCount(Card.GetCode)
	if ft>ct then ft=ct end
	local sg=aux.SelectUnselectGroup(g,e,tp,ft,ft,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(aux.TRUE,0,LOCATION_FZONE,LOCATION_FZONE,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end