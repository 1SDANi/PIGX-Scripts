--レインボー・ネオス
--Rainbow Neos
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,CARD_NEOS,aux.FilterBoolFunctionEx(Card.IsSetCard,0x2034))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--send monsters to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(s.tdtg1)
	e2:SetOperation(s.tdop1)
	c:RegisterEffect(e2)
	--send spell/trap to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(s.tdtg2)
	e3:SetOperation(s.tdop2)
	c:RegisterEffect(e3)
	--send GY to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(s.tdtg3)
	e4:SetOperation(s.tdop3)
	c:RegisterEffect(e4)
end
s.listed_series={0x2034}
s.listed_names={CARD_NEOS}
s.material_setcode={0x8,0x3008,0x9,0x34,0x2034}
function s.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_MZONE)
end
function s.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function s.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_ONFIELD)
end
function s.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.tdtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_GRAVE)
end
function s.tdop3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end