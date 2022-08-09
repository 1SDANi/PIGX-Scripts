--ナチュル・ストロベリー
--Naturia Strawberry
local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.filter(c,tp)
	return c:IsLevelAbove(2) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(s.filter,1,nil,1-tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,1-tp)
	for tc in aux.Next(g) do
		--Halve its original ATK
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
