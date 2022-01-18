--神秘の中華なべ
--Mystik Wok
local s,id=GetID()
function s.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local stats=g:GetFirst():GetAttack()+g:GetFirst():GetDefense()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(stats)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,stats)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,g=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_CARDS)
	local stats=g:GetFirst():GetAttack()+g:GetFirst():GetDefense()
	Duel.Recover(p,stats,REASON_EFFECT)
end