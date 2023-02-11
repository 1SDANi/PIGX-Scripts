--アーマロイドガイデンゴー
--Super Vehicroid Armoroid
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixN(c,true,true,s.fusfilter,3)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,s.eqcon,s.eqval,s.equipop,e1)
end
s.material_setcode={0x16}
function s.fusfilter(c)
	return c:IsSetCard(0x16) and (c:IsType(TYPE_MONSTER) or c:IsOriginalType(TYPE_MONSTER))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter,nil)
	return #g==0
end
function s.eqfilter(c)
	return c:GetFlagEffect(id)~=0 
end
function s.eqval(ec,c,tp)
	return ec:IsControler(tp)
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,id) then return false end
	return true
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsSetCard(0x16) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,0x16) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,0x16)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function s.repval(e,re,r,rp)
	return r&REASON_BATTLE~=0 or r&REASON_EFFECT~=0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		for tc in aux.Next(g) do
			if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and s.equipop(c,e,tp,tc) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(s.repval)
				tc:RegisterEffect(e2)
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
			end
		end
	end
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end