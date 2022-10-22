--トライワイトゾーン
--Tri-Wight Zone
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.ctfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.ctfilter(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if chk==0 then return ft>0 and Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local c=ft
	if c>3 then c=3 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then c=1 end
	if #g==0 then return end
	local sg=Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_GRAVE,0,1,3,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then c=1 end
	if #g==0 or ft<#g then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end