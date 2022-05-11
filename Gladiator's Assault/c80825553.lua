--Cloudian - Smoke Ball
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetCondition(aux.IsGeminiState)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.IsGeminiState)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
s.counter_list={COUNTER_FOG}
function s.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_FOG,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local ct=0
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		ct=ct+tc:GetLevel()
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=1
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		lv=tc:GetLevel()
		if tc and tc:HasLevel() and tc:IsCanAddCounter(COUNTER_FOG,1) then
			tc:AddCounter(COUNTER_FOG,1)
		end
	end
end