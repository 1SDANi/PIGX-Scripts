--アルカナフォースⅥ－THE LOVERS
--Arcana Force VI - The Lovers
local s,id=GetID()
function s.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.cointg)
	e1:SetOperation(s.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--double tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e4:SetCondition(s.heads)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
	--triple tribute
	local e5=e4:Clone()
	e5:SetCode(EFFECT_TRIPLE_TRIBUTE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DECREASE_TRIBUTE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	e6:SetCondition(s.tails)
	e6:SetValue(0x1)
	c:RegisterEffect(e6)
end
s.listed_series={0x5}
s.toss_coin=true
function s.heads(e)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function s.tails(e)
	return e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c:RegisterFlagEffect(36690018,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,res,63-res)
end