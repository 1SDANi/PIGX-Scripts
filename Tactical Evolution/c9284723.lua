--ヴェノム・ボア
--Venom Boa
local s,id=GetID()
function s.initial_effect(c)
	--Place 1 venom counter on 1 of opponent's monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKDEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.counter_place_list={COUNTER_VENOM}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,COUNTER_VENOM,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,5,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	for i=1,counters do
		local sg=g:Select(tp,1,1,nil)
		if sg:GetFirst():IsCanAddCounter(COUNTER_VENOM,1) and sg:GetFirst():AddCounter(COUNTER_VENOM,1) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-500)
			sg:GetFirst():RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sg:GetFirst():RegisterEffect(e2)
		end
	end
end