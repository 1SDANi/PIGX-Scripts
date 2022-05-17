--デモンバルサム・シード
--Sinister Seeds
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.ceil(Duel.GetBattleDamage(tp)/1000)
	if chk==0 then return val>0 and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_AVOID_BATTLE_DAMAGE) and
		Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,100,100,1,RACE_PLANT,ATTRIBUTE_DARK)end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local val=math.ceil(Duel.GetBattleDamage(tp)/1000)
	if (val>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<val
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,100,100,1,RACE_PLANT,ATTRIBUTE_DARK) then return end
	for i=1,val do
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
