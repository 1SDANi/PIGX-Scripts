--聖騎士伝説の終幕
--Repose of the Holy Knight
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0xa7,0x207a,0xa8}
function s.cfilter1(c,e,tp)
	return c:IsSetCard(0xa7) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.cfilter2(c,e,tp)
	return c:IsSetCard(0x207a) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g1:GetFirst(),g2:GetFirst())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local mc,ec=e:GetLabelObject()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetLabelObject(ec)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	mc:RegisterEffect(e1)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0xa8) and c:IsLevelBelow() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local success=aux.FALSE
		if c:IsType(TYPE_FUSION) and Duel.SpecialSummon(c,SUMMON_FUSION,tp,tp,false,false,POS_FACEUP) then
			success=aux.TRUE
		else if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
			success=aux.TRUE
		end
		if success then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.Equip(tp,e:GetLabelObject(),c)
			end
			if c:IsType(TYPE_GEMINI) then
				local fid=c:GetFieldID()
				tc:EnableGeminiState()
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			else if c:IsType(TYPE_FUSION) then
				if c:IsLevelAbove(5) then
					tc:AddCounter(COUNTER_XYZ,3)
				else
					tc:AddCounter(COUNTER_XYZ,2)
				end
			else if c:IsLevelBelow(3) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
				if #g>0 then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end