--トーチ・ゴーレム
--Grinder Golem
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_names={75732623}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,300,300,1,RACE_FIEND,ATTRIBUTE_DARK)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,3,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,id+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
	if Duel.SpecialSummonComplete()>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	
end
function s.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
