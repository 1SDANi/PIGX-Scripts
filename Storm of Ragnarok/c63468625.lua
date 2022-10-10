--機皇神マシニクル∞
--Meklord Astro Mekanikle
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)
	aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e4)
end
s.listed_series={0x13}
function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,id) then return false end
	return true
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and s.equipop(c,e,tp,tc) then
		--atk up
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(tc:GetAttack())
		tc:RegisterEffect(e3)
		--def up
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		e4:SetValue(tc:GetDefense())
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		--special summon
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(id,1))
		e5:SetCategory(CATEGORY_DAMAGE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetType(EFFECT_TYPE_IGNITION)
		e5:SetRange(LOCATION_SZONE)
		e5:SetCost(s.cs)
		e5:SetTarget(s.tg)
		e5:SetOperation(s.op)
		c:RegisterEffect(e5)
	end
end
function s.cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.spfilter(c)
	return c:IsSetCard(0x13) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end