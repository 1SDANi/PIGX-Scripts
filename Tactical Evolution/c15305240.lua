--鹵獲装置
--Creature Seizure
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
function s.normalfilter(c)
	return (c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_DECK))) and c:IsFaceup()
end
function s.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.normalfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(1-tp,s.filter,1-tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.GetControl(g:GetFirst(),tp)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.GetControl(g:GetFirst(),1-tp)
		end
	end
end