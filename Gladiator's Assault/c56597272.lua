--雲魔物－羊雲
--Cloudian - Sheep Cloud
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.counter_list={COUNTER_FOG}
s.listed_names={56597273}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x18,TYPES_TOKEN,0,0,1,RACE_ELEMENTAL,ATTRIBUTE_WIND) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,id+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e0:SetValue(1)
			token:RegisterEffect(e0)
			--Cannot be used as fusion material
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3309)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			token:RegisterEffect(e1)
			token:AddCounter(COUNTER_FOG,1)
		end
	end
end