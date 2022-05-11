--雲魔物－タービュランス
--Cloudian - Turbulence
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
end
s.listed_series={0x18}
function s.filter(c,e,tp)
	return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP_ATTACK)
		--Cannot be used as fusion material
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3309)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		g:GetFirst():RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end