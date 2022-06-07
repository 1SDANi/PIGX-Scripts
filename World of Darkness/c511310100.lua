--ダークネス
--Darkness
local s,id=GetID()
function s.initial_effect(c)
	--cannot activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetRange(LOCATION_FZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetValue(s.efilter)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.aclimit1)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(s.aclimit2)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(s.econ)
	e5:SetValue(s.elimit)
	c:RegisterEffect(e5)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e22:SetCode(EVENT_CHAINING)
	e22:SetRange(LOCATION_FZONE)
	e22:SetOperation(s.aclimit12)
	c:RegisterEffect(e22)
	local e42=Effect.CreateEffect(c)
	e42:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e42:SetCode(EVENT_CHAIN_NEGATED)
	e42:SetRange(LOCATION_FZONE)
	e42:SetOperation(s.aclimit22)
	e42:SetLabelObject(e22)
	c:RegisterEffect(e42)
	local e52=Effect.CreateEffect(c)
	e52:SetType(EFFECT_TYPE_FIELD)
	e52:SetCode(EFFECT_CANNOT_ACTIVATE)
	e52:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e52:SetRange(LOCATION_FZONE)
	e52:SetTargetRange(1,0)
	e52:SetCondition(s.econ2)
	e52:SetValue(s.elimit2)
	c:RegisterEffect(e52)
	--Cannot look
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e6:SetCode(EFFECT_DARKNESS_HIDE)
	e6:SetValue(function(e,c) return c:IsFacedown(id) end)
	c:RegisterEffect(e6)
	--Rearrange
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCondition(s.setcn)
	e7:SetOperation(s.setop)
	c:RegisterEffect(e7)
	--cannot be target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetRange(LOCATION_FZONE)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e8:SetTarget(s.etarget)
	e8:SetValue(aux.TRUE)
	c:RegisterEffect(e8)
	--Destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCondition(s.descon)
	e9:SetOperation(s.desop)
	c:RegisterEffect(e9)
end
function s.efilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.cfilter(c,e,tp)
	return c==e:GetHandler() or (c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_TRAP) and
		c:IsType(TYPE_CONTINUOUS)) or (c:IsPreviousPosition(POS_FACEDOWN) and c:IsType(TYPE_TRAP+TYPE_SPELL))
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp) and re and re:GetHandler()~=e:GetHandler()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.etarget(e,c)
	return (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()) or c==e:GetHandler() or (c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsFacedown())
end
function s.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function s.setcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN)
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.ShuffleSetCard(Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE):Filter(function(c)return c:GetSequence()<5 end,nil))
		g:ForEach(function(c)c:SetStatus(STATUS_SET_TURN,true)end)
	end
end
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	Duel.SetChainLimit(aux.FALSE)
	if re:GetCategory()&CATEGORY_ACTIVATE==0 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_CONTROL|RESET_PHASE|PHASE_END,0,1)
	end
end
function s.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(id)
	e:GetLabelObject():SetLabel(0)
end
function s.econ(e)
	return e:GetHandler():GetFlagEffect(id)~=0 and Duel.GetCurrentChain()==0
end
function s.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.aclimit12(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	Duel.SetChainLimit(aux.FALSE)
	if re:GetCategory()&CATEGORY_ACTIVATE==0 then
		e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_CONTROL|RESET_PHASE|PHASE_END,0,1)
	end
end
function s.aclimit22(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(id+1)
	e:GetLabelObject():SetLabel(0)
end
function s.econ2(e)
	return e:GetHandler():GetFlagEffect(id+1)~=0 and Duel.GetCurrentChain()==0
end
function s.elimit2(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable(true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)<5 then return end
	Duel.BreakEffect()
	local sg1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
	if sg1:GetClassCount(Card.GetCode)>=5 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local sg1=aux.SelectUnselectGroup(sg1,e,tp,5,5,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
		if #sg1>0 then
			Duel.SSet(tp,sg1)
			Duel.ShuffleSetCard(sg1)
		end
	end
	local sg2=Duel.GetMatchingGroup(s.filter,1-tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
	if sg2:GetClassCount(Card.GetCode)>=5 and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		local sg2=aux.SelectUnselectGroup(sg2,e,tp,5,5,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
		if #sg2>0 then
			Duel.SSet(1-tp,sg2)
			Duel.ShuffleSetCard(sg2)
		end
	end
end