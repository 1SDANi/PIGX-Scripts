--CNo.39 希望皇ホープレイ
--Chaos Number 39: Hope Ray
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_XYZ)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,3,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	local chaos=Effect.CreateEffect(c)
	chaos:SetType(EFFECT_TYPE_IGNITION)
	chaos:SetDescription(1170)
	chaos:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP)
	chaos:SetRange(LOCATION_EXTRA)
	chaos:SetCategory(CATEGORY_SPECIAL_SUMMON)
	chaos:SetTarget(s.chaostg)
	chaos:SetOperation(s.chaosop)
	c:RegisterEffect(chaos)
	local xyz=Effect.CreateEffect(c)
	xyz:SetDescription(6666)
	xyz:SetCategory(CATEGORY_COUNTER)
	xyz:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	xyz:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	xyz:SetCode(EVENT_SPSUMMON_SUCCESS)
	xyz:SetCondition(s.xyzcn)
	xyz:SetTarget(s.xyztg)
	xyz:SetOperation(s.xyzop)
	c:RegisterEffect(xyz)
	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKDEFCHANGE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.xyz_number=39
s.counter_place_list={COUNTER_XYZ}
s.listed_series={0x48}
s.listed_names={84013237}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,COUNTER_XYZ,1,REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(-1000)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				g:GetFirst():RegisterEffect(e2)
			end
		end
	end
end
function s.chaosfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsCode(84013237)
end
function s.chaostg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.chaosfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.chaosop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.chaosfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		e:GetHandler():SetMaterial(Group.FromCards(tc))
		local ct=tc:GetCounter(COUNTER_XYZ)
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(e:GetHandler(),SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) and ct>0 then
			e:GetHandler():AddCounter(COUNTER_XYZ,ct)
		end
		Duel.SpecialSummonComplete()
		e:GetHandler():CompleteProcedure()
	end
end
function s.indes(e,c)
	return not c:IsSetCard(0x48)
end
function s.xyzcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,COUNTER_XYZ)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetMaterialCount()
	if e:GetHandler():IsRelateToEffect(e) and ct and ct>0 then
		e:GetHandler():AddCounter(COUNTER_XYZ,ct)
	end
end
function s.fusionfilter(c,fc,sumtype,sp,sub,mg,sg)
	local lv=fc:GetLevel()
	return c:HasLevel() and c:IsLevel(lv)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end