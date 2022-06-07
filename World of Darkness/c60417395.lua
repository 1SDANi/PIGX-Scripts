--ダークネス・ネオスフィア
--Dark Neosphere
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e2=aux.AddNormalSetProcedure(c)
	--confirm
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.tg)
	e0:SetOperation(s.op)
	c:RegisterEffect(e0)
	--rearrange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--Change LP
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.lptg)
	e4:SetOperation(s.lpop)
	c:RegisterEffect(e4)
	--atk/def
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SET_BASE_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.adval)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e9)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.SetLP(p,4000)
end
function s.fieldfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsCanTurnSet()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.fieldfilter,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.fieldfilter,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	local tc=sg:GetFirst()
	while tc do
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		tc=sg:GetNext()
	end
	Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,1-tp,tp,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
end
function s.refilter(c)
	return c:GetSequence()<5 and c:IsFaceup() and c:IsCanTurnSet()
end
function s.setfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g==0 then return end
	local p
	if g:GetClassCount(Card.GetControler)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		p=g:Select(tp,1,1,nil):GetFirst():GetControler()
		g=g:Filter(Card.IsControler,nil,p)
	else
		p=g:GetFirst():GetControler()
	end
	local sg=g:Filter(s.setfilter,nil)
	if #sg>0 then
		Duel.SSet(tp,sg)
		Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	g=g:Filter(Card.IsFacedown,nil)
	local filter=s.getflag(g,tp)
	for tc in aux.Next(g) do
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone=Duel.SelectFieldZone(tp,1,LOCATION_SZONE,LOCATION_SZONE,filter)
		filter=filter|zone
		local seq=math.log(zone>>8,2)
		local oc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		if oc then
			Duel.SwapSequence(tc,oc)
		else
			Duel.MoveSequence(tc,seq)
		end
	end
end
function s.adval(e,c)
	return Duel.GetLP(e:GetHandler():GetControler())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
	end
end