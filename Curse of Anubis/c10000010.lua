--ラーの翼神竜
--The Winged Dragon of Ra
local s,id=GetID()
function s.initial_effect(c)
	--return to previous location
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCondition(s.tgcon)
	e0:SetTarget(s.tgtg)
	e0:SetOperation(s.tgop)
	c:RegisterEffect(e0)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,false,3,3)
	local e2=aux.AddNormalSetProcedure(c)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--One Turn Kill
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCost(s.atkcost)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(s.descost)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)
	--atk/def
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.adval)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and e:GetHandler():GetPreviousLocation()~=0
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SPECIAL) then
		if c:IsPreviousLocation(LOCATION_GRAVE) then
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
		elseif c:IsPreviousLocation(LOCATION_DECK) then
			Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
		elseif c:IsPreviousLocation(LOCATION_HAND) then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
		elseif c:IsPreviousLocation(LOCATION_REMOVED) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
		end
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SPECIAL) then
		if c:IsPreviousLocation(LOCATION_GRAVE) then
			Duel.SendtoGrave(c,REASON_RULE,c:GetPreviousControler())
		elseif c:IsPreviousLocation(LOCATION_DECK) then
			Duel.SendtoDeck(c,c:GetPreviousControler(),2,REASON_EFFECT)
		elseif c:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(c,c:GetPreviousControler(),REASON_EFFECT)
		elseif c:IsPreviousLocation(LOCATION_REMOVED) then
			Duel.Remove(c,c:GetPreviousPosition(),REASON_EFFECT,c:GetPreviousControler())
		end
	end
end
function s.adval(e,c)
	return Duel.GetLP(tp)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetDescription(aux.Stringid(id,3))
		e3:SetTargetRange(0,1)
		e3:SetValue(s.aclimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
