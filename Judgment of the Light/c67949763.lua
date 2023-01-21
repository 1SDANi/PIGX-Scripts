--罪鍵の法－シン・キー・ロウ
--Corrupted Keys
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={67949764}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function s.val(e,c)
	local g=Duel.GetMatchingGroup(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	return g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 then
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x87,TYPES_TOKEN,-2,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
		for i=1,3 do
			local token=Duel.CreateToken(tp,id+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(s.val)
			token:RegisterEffect(e2)
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
			e5:SetRange(LOCATION_MZONE)
			e5:SetValue(1)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e5,true)
		end
		Duel.SpecialSummonComplete()
	end
end