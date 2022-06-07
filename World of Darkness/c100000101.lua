--おジャマンダラ
--Ojamandala
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
s.listed_names={42941100,79335209,12482652}
function s.ctfilter(c,e,tp)
	return c:IsCode(42941100,79335209,12482652) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ctcheck(sg,e,tp)
	return sg:GetClassCount(Card.GetCode)==#sg
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.ctfilter(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and ft>0 and e:GetHandler():IsReleasable() and
		Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)  end
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local c=ft
	if c>3 then c=3 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then c=1 end
	if #g==0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,c,s.ctcheck,1,tp,HINTMSG_SPSUMMON)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if #g==0 or ft<#g then return end
	if Duel.Release(e:GetHandler(),REASON_COST) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end