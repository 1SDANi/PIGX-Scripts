--ダークネス ３
--i
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.flagfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function s.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:GetFlagEffect(id)==0 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.flagfilter,tp,LOCATION_SZONE,0,e:GetHandler())
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_CONTROL|RESET_CHAIN,0,1)
		end
		return true
	end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_SZONE,0,nil)
	if ct>3 then ct=3 end
	if ct>0 and Duel.GetFieldGroupCount(tp,GetLocationCount)<=0 and Duel.GetLocationCount(tp,LOCATION_FZONE)<=0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000*ct)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000*ct)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p and d and d>0 then
		Duel.Damage(p,d,REASON_EFFECT)
	end
end