--トラックロイド
--Truckroid
local s,id=GetID()
function s.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,s.eqcon,s.eqval,s.equipop,e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter,nil)
	return #g==0
end
function s.eqfilter(c)
	return c:GetFlagEffect(id)~=0 
end
function s.eqval(ec,c,tp)
	return ec:IsControler(1-tp)
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,id) then return false end
	return true
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsFaceup() and tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) 
		and not tc:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
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
		tc:RegisterEffect(e4)
	end
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetEquipTarget()==e:GetHandler() end
	if chk==0 then return e:GetHandler():GetEquipCount()~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(e:GetHandler():GetBaseAttack()*2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetValue(e:GetHandler():GetBaseDefense()*2)
		e:GetHandler():RegisterEffect(e3)
	end
end