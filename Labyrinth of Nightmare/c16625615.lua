--ダーク・サンクチュアリ
--Dark Sanctuary
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.tg2)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_names={16625615}
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local p=Duel.GetTurnPlayer()
	local ft1=Duel.GetLocationCount(p,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(p,LOCATION_SZONE)
	if chk==0 then return not (Duel.IsExistingTarget(aux.TRUE,p,0,LOCATION_MZONE,1,nil) and ft1>0 and ft2>0 and
		Duel.IsPlayerCanSpecialSummonMonster(p,id+1,0,TYPES_TOKEN,0,0,1,RACE_ELEMENTAL,ATTRIBUTE_DARK)) end
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local p=Duel.GetTurnPlayer()
	local ft1=Duel.GetLocationCount(p,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(p,LOCATION_SZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-p) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,p,0,LOCATION_MZONE,1,nil) and ft1>0 and ft2>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_ELEMENTAL,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(p,aux.TRUE,p,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local tc=Duel.GetFirstTarget()
	if not Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_ELEMENTAL,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,id+i)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		if tc and tc:IsRelateToEffect(e) then
			Duel.Equip(tp,g,tc,true)
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(true)
			g:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_BATTLE_CONFIRM)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetRange(LOCATION_SZONE)
			e2:SetTarget(s.target)
			e2:SetOperation(s.operation)
			g:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local eq=e:GetHandler():GetEquipTarget()
	local atk=eq:GetAttack()
	if chk==0 then return eq and Duel.GetAttacker()==eq end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.NegateAttack()
	Duel.BreakEffect()
	local heal=Duel.Damage(p,d,REASON_EFFECT)
	if heal>0 then
		Duel.Recover(1-p,heal,REASON_EFFECT)
	end
end