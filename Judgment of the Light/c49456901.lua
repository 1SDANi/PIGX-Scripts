--CNo.104 仮面魔踏士アンブラル
--Chaos Number 104: Umbral Horror Masquerade
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
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.xyz_number=104
s.counter_place_list={COUNTER_XYZ}
s.listed_series={0x48}
s.listed_names={2061963}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RemoveCounter(tp,COUNTER_XYZ,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.chaosfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsCode(2061963)
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
	return c:IsLevel(lv)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end