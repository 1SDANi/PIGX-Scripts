--剣闘獣ベストロウリィ
--Gladiator Beast Bestiari
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x19}
s.listed_names={id}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function s.filter(c,e,tp)
	return not c:IsCode(id) and c:IsLevelBelow(4) and c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,102,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,102,tp,tp,false,false,POS_FACEUP)>0 then
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD_DISABLE,0,0)
		if Duel.IsExistingMatchingCard(s.dfilter,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,s.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #dg>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
