--光と闇の竜
--Light and Darkness Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.codisable)
	e3:SetTarget(s.tgdisable)
	e3:SetOperation(s.opdisable)
	c:RegisterEffect(e3)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,4))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(s.cdspsum)
	e4:SetTarget(s.tgspsum)
	e4:SetOperation(s.opspsum)
	c:RegisterEffect(e4)
end
s.material_attribute={ATTRIBUTE_DARK,ATTRIBUTE_LIGHT}
function s.fusionfilter(c,fc,sumtype,sp,sub,mg,sg)
	local tg=fc:GetLevel()
	local rg
	local st
	if mg then
		rg=mg-sg
	end
	if sg then
		st=sg:GetSum(Card.GetLevel)
	end
	return (not rg or not sg or st==tg or (st<tg and rg:CheckWithSumEqual(Card.GetLevel,tg-st,1,99))) and
		c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and
		(not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:FilterCount(aux.TRUE,c)>1 or
		((not sg:IsExists(Card.IsAttribute,1,c,c:GetAttribute()))))
		
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function s.codisable(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	if c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.opdisable(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or c:GetDefense()<500 or c:GetAttack()< 500 or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	if Duel.NegateActivation(ev) then
		if c:UpdateAttack(-500,nil)==-500 and c:UpdateDefense(-500,nil)==-500 and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
	end
end
function s.cdspsum(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.tgspsum(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function s.opspsum(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
