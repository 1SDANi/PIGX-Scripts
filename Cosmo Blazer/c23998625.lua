--No.53 偽骸神 Heart－eartH
--Number 53: False God Heart-eartH
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_XYZ)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,3,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
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
	--reflect battle dam
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e00:SetValue(1)
	c:RegisterEffect(e00)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.eqcn)
	e1:SetCost(s.eqcs)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,aux.TRUE,s.equipop,e1)
	--fusion summon
	local params = {nil,Fusion.CheckWithHandler(Fusion.OnFieldMat(aux.FilterBoolFunction(Card.IsCode,97403510))),nil,nil,Fusion.ForcedHandler}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e2:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e2)
end
s.xyz_number=53
s.counter_place_list={COUNTER_XYZ}
s.listed_series={0x48}
s.listed_names={97403510}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget() and e:GetHandler():IsRelateToEffect(e)
		and Duel.GetAttacker():IsFaceup() and Duel.GetAttackTarget():IsFaceup() and e:GetHandler():GetCounter(COUNTER_XYZ)<=0
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,id) then return false end
	return true
end
function s.eqcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget() and e:GetHandler():IsRelateToEffect(e) and Duel.GetAttacker():IsFaceup() and Duel.GetAttackTarget():IsFaceup()
end
function s.eqcs(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,COUNTER_XYZ,1,REASON_COST)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetAttacker()
	if c==Duel.GetAttacker() then a=Duel.GetAttackTarget() end
	if not a:IsFaceup() then return end
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and s.equipop(c,e,tp,tc) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_DESTROY_REPLACE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetTarget(s.desreptg)
		e2:SetOperation(s.desrepop)
		e2:SetLabel(a:GetAttack())
		tc:RegisterEffect(e2)
		--atk up
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(a:GetAttack())
		tc:RegisterEffect(e3)
	end
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup() and c:IsDestructable(e) end
	if Duel.SelectEffectYesNo(tp,c,96) then return true else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	Duel.BreakEffect()
	local dam=Duel.Damage(1-tp,atk,REASON_EFFECT)
	if dam>0 then
		Duel.Recover(tp,dam,REASON_EFFECT)
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