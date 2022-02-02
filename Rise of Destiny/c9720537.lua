--所有者の刻印
--Owner's Seal
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsControlerCanBeChanged() and not c:IsControler(c:GetOwner())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,#g,0,0)
end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=0
	for tc in aux.Next(g) do
		if Duel.GetControl(tc,tc:GetOwner())>0 then
			ct=ct+1
		end
	end
	if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end