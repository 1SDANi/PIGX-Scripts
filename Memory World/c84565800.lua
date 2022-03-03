--伝説の騎士 ヘルモス
--Legendary Knight Hermos
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--gain effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.cn)
	e1:SetCost(s.cs)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.listed_names={89397517}
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt:GetControler()==c:GetControler()
end
function s.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(e:GetLabel())
	e:SetLabel(0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local bt=eg:GetFirst()
	if ac==0 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:CopyEffect(ac,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		Duel.BreakEffect()
		if bt~=e:GetHandler() and Duel.GetAttacker():GetAttackableTarget():IsContains(e:GetHandler()) and
				(not Duel.GetAttacker():IsImmuneToEffect(e)) and e:GetHandler():IsRelateToEffect(e) then
			Duel.ChangeAttackTarget(c)
		end
	end
end