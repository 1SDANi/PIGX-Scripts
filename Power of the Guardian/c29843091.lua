--おジャマトリオ
--Ojama Trio
local s,id=GetID()
function s.initial_effect(c)
	--Special summon 3 tokens to opponent's field
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
s.listed_names={TOKEN_OJAMA}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_OJAMA,0xf,TYPES_TOKEN,0,1000,2,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<3 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_OJAMA,0xf,TYPES_TOKEN,0,1000,2,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) then return end
	for i=0,2 do
		local token=Duel.CreateToken(tp,TOKEN_OJAMA+i)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
			--Cannot be tributed
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(3303)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_UNRELEASABLE_SUM)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e4,true)
			--Cannot be used as fusion material
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetDescription(3309)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e5:SetValue(1)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e5,true)
			--Inflict 300 damage when destroyed
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetOperation(s.damop)
			token:RegisterEffect(e2,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),500,REASON_EFFECT)
	end
	e:Reset()
end