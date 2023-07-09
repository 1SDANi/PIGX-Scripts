--影依の原核
--Shaddoll Core
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,e:GetHandler():GetAttribute())
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and g and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,#eg,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,e:GetHandler():GetAttribute())
	if e:GetHandler():IsRelateToEffect(e) and g and #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_EARTH) or 
	Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_WATER) or 
	Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_FIRE) or 
	Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_WIND) or 
	Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) or 
	Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_DIVINE)) end
	local att=0
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_EARTH) then
		att+ATTRIBUTE_EARTH
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_WATER) then
		att+ATTRIBUTE_WATER
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_FIRE) then
		att+ATTRIBUTE_FIRE
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_WIND) then
		att+ATTRIBUTE_WIND
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) then
		att+ATTRIBUTE_LIGHT
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+ATTRIBUTE_DIVINE) then
		att+ATTRIBUTE_DIVINE
	end
	local rc=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,3000,2500,9,RACE_ELEMENTAL,ATTRIBUTE_DARK+rc) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	--Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(rc)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)
end