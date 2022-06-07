--クリアー・ワールド
--Clear World
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Negate the effects of Effect Monsters you control.
	local lightA=Effect.CreateEffect(c)
	lightA:SetType(EFFECT_TYPE_FIELD)
	lightA:SetRange(LOCATION_FZONE)
	lightA:SetTargetRange(LOCATION_MZONE,0)
	lightA:SetCode(EFFECT_DISABLE)
	lightA:SetCondition(s.lightconditionA)
	lightA:SetTarget(aux.TRUE)
	c:RegisterEffect(lightA)
	local lightB=lightA:Clone()
	lightB:SetTargetRange(0,LOCATION_MZONE)
	lightB:SetCondition(s.lightconditionB)
	c:RegisterEffect(lightB)
	--Monsters you control cannot declare an attack.
	local darkA=Effect.CreateEffect(c)
	darkA:SetType(EFFECT_TYPE_FIELD)
	darkA:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	darkA:SetRange(LOCATION_FZONE)
	darkA:SetTargetRange(LOCATION_MZONE,0)
	darkA:SetCondition(s.darkconditionA)
	darkA:SetTarget(aux.TRUE)
	c:RegisterEffect(darkA)
	local darkB=darkA:Clone()
	darkB:SetTargetRange(0,LOCATION_MZONE)
	darkB:SetCondition(s.darkconditionB)
	c:RegisterEffect(darkB)
	--Once per turn, during your End Phase: Destroy 1 monster you control.
	local earthA=Effect.CreateEffect(c)
	earthA:SetDescription(aux.Stringid(id,0))
	earthA:SetCategory(CATEGORY_DESTROY)
	earthA:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	earthA:SetCode(EVENT_PHASE+PHASE_END)
	earthA:SetRange(LOCATION_FZONE)
	earthA:SetCountLimit(1)
	earthA:SetCondition(s.earthconditionA)
	earthA:SetTarget(s.earthtargetA)
	earthA:SetOperation(s.earthoperationA)
	c:RegisterEffect(earthA)
	local earthB=earthA:Clone()
	earthB:SetCondition(s.earthconditionB)
	earthB:SetTarget(s.earthtargetB)
	earthB:SetOperation(s.earthoperationB)
	c:RegisterEffect(earthB)
	--Once per turn, during your End Phase: Destroy 1 Spell/Trap you control.
	local windA=Effect.CreateEffect(c)
	windA:SetDescription(aux.Stringid(id,0))
	windA:SetCategory(CATEGORY_DESTROY)
	windA:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	windA:SetCode(EVENT_PHASE+PHASE_END)
	windA:SetRange(LOCATION_FZONE)
	windA:SetCountLimit(1)
	windA:SetCondition(s.windconditionA)
	windA:SetTarget(s.windtargetA)
	windA:SetOperation(s.windoperationA)
	c:RegisterEffect(windA)
	local windB=windA:Clone()
	windB:SetCondition(s.windconditionB)
	windB:SetTarget(s.windtargetB)
	windB:SetOperation(s.windoperationB)
	c:RegisterEffect(windB)
	--You cannot activate Spells.
	local waterA=Effect.CreateEffect(c)
	waterA:SetType(EFFECT_TYPE_FIELD)
	waterA:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	waterA:SetCode(EFFECT_CANNOT_ACTIVATE)
	waterA:SetRange(LOCATION_FZONE)
	waterA:SetTargetRange(1,0)
	waterA:SetValue(s.wateraclimit)
	waterA:SetCondition(s.waterconditionA)
	c:RegisterEffect(waterA)
	local waterB=waterA:Clone()
	waterB:SetTargetRange(0,1)
	waterB:SetCondition(s.waterconditionB)
	c:RegisterEffect(waterB)
	--You cannot activate Traps.
	local fireA=Effect.CreateEffect(c)
	fireA:SetType(EFFECT_TYPE_FIELD)
	fireA:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	fireA:SetCode(EFFECT_CANNOT_ACTIVATE)
	fireA:SetRange(LOCATION_FZONE)
	fireA:SetTargetRange(1,0)
	fireA:SetValue(s.fireaclimit)
	fireA:SetCondition(s.fireconditionA)
	c:RegisterEffect(fireA)
	local fireB=fireA:Clone()
	fireB:SetTargetRange(0,1)
	fireB:SetCondition(s.fireconditionB)
	c:RegisterEffect(fireB)
	
end
function s.cfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.lightconditionA(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,ATTRIBUTE_LIGHT)
end
function s.lightconditionB(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT)
end
function s.darkconditionA(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK)
end
function s.darkconditionB(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil,ATTRIBUTE_DARK)
end
function s.earthconditionA(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_EARTH)
end
function s.earthtargetA(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.earthoperationA(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function s.earthconditionB(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil,ATTRIBUTE_EARTH)
end
function s.earthtargetB(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.earthoperationB(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function s.windtargetA(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.windconditionA(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil,ATTRIBUTE_WIND)
end
function s.windoperationA(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function s.windconditionB(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil,ATTRIBUTE_WIND)
end
function s.windtargetB(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.windoperationB(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(1-tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function s.wateraclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function s.waterconditionA(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER)
end
function s.waterconditionB(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
end
function s.fireaclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function s.fireconditionA(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,ATTRIBUTE_FIRE)
end
function s.fireconditionB(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
end