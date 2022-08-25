--BF－激震のアブロオロス
--Blackwing - Abrolhos the Megaquake
local s,id=GetID()
function s.initial_effect(c)
	--to hand1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to hand2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetOperation(s.operation2)
	c:RegisterEffect(e4)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x3e),e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=1000 and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		c:RegisterEffect(e1)
	end
end
function s.indestg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end
