--ナチュラル・ボーン・サウルス
--Skelesaurus
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(ATTRIBUTE_DARK)
	e0:SetCondition(aux.IsGeminiState)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e00:SetCode(EFFECT_ADD_RACE)
	e00:SetRange(LOCATION_MZONE)
	e00:SetValue(RACE_ZOMBIE)
	e00:SetCondition(aux.IsGeminiState)
	c:RegisterEffect(e00)
	local e000=Effect.CreateEffect(c)
	e000:SetType(EFFECT_TYPE_SINGLE)
	e000:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e000:SetRange(LOCATION_MZONE)
	e000:SetCode(EFFECT_UPDATE_ATTACK)
	e000:SetCondition(aux.IsGeminiState)
	e000:SetValue(1000)
	c:RegisterEffect(e000)
	local e0000=e000:Clone()
	e0000:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e0000)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(s.spcn)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcn(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdogcon(e,tp,eg,ep,ev,re,r,rp) and aux.IsGeminiState(e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end