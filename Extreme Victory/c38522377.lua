--機皇神龍アステリスク
--Meklord Astro Dragon Asterisk
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.damcon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(s.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetValue(s.defval)
	c:RegisterEffect(e8)
end
s.listed_series={0x13}
s.listed_names={id}
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t1=false
	local t2=false
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_FUSION) then
			if tc:IsSummonPlayer(tp) then t1=true else t2=true end
		end
	end
	if t1 and not t2 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	elseif not t1 and t2 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	else Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000) end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
	if dp~=PLAYER_ALL then Duel.Damage(dp,1000,REASON_EFFECT)
	else
		Duel.Damage(tp,1000,REASON_EFFECT,true)
		Duel.Damage(1-tp,1000,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x13)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,c) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,c)
		Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function s.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13) and not c:IsCode(id)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(s.vfilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseAttack)
end
function s.defval(e,c)
	local g=Duel.GetMatchingGroup(s.vfilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseDefense)
end
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,3,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end