--The Wicked God Zorc Necrophades
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,false,true,true,s.fusfilter,7)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.effcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
	--win duel
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_FLAG_UNCOPYABLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(s.wincon)
	e5:SetOperation(s.winop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e6:SetCountLimit(1)
	e6:SetValue(s.valcon)
	c:RegisterEffect(e6)
end
s.listed_series={0x40,0x302}
s.material_setcode={0x302}
s.listed_names={1000009}
function s.fusfilter(c)
	return c:IsSetCard(0x302) and c:IsType(TYPE_MONSTER+TYPE_UNION) and c:IsType(TYPE_FUSION)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end
function s.valtg(e,c)
	if c:GetFlagEffect(id)~=0 then return false end
	c:RegisterFlagEffect(id,0,0,1)
	return true
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end
function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_MZONE)==0
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,WIN_REASON_ZORC_NECROPHADES)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then	return Duel.GetAttacker()==e:GetHandler() and t~=nil and t:IsControler(1-tp) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.forbiddenfilter(c)
	return ((not c:IsLocation(LOCATION_REMOVED)) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x40)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() and t:IsControler(1-tp) then
		if Duel.IsExistingMatchingCard(s.forbiddenfilter,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_REMOVED,1,nil) and
			Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
			local sg=Duel.GetMatchingGroup(s.forbiddenfilter,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_REMOVED,nil)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			if Duel.NegateAttack() then
				Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
			end
		else
			if Duel.SelectYesNo(1-tp,aux.Stringid(id,4)) and Duel.NegateAttack() then
				local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.filter(c,e,tp)
	return c:IsCode(1000009) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstMatchingCard(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,1-tp,true,true,POS_FACEUP)
end
function s.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end