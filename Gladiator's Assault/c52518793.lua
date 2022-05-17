--剣闘獣の檻－コロッセウム
--Colosseum - Cage of the Gladiator Beasts
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x7)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c.condition)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--Prevent destruction by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
s.listed_series={0x19}
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x19) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.repfilter,nil)
	local ct=g:GetSum(Card.GetLevel)
	if chk==0 then return e:GetHandler():GetCounter(0x7)>=ct end
	e:SetLabel(ct)
	return e:GetHandler():GetCounter(0x7)>=ct
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e)
	e:GetHandler():RemoveCounter(e:GetHandler():GetControler(),0x7,e:GetLabel(),REASON_EFFECT)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x19)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	local ct=g:GetSum(Card.GetLevel)
	e:GetHandler():AddCounter(0x7,ct)
end
function s.filter(c)
	return c:IsSetCard(0x19) and c:IsDiscardable()
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,s.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)
end