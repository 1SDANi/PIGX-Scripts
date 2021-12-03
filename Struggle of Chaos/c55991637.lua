--火竜の火炎弾
--Dragon's Gunfire
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsDefenseBelow(1600)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b2=Duel.IsExistingTarget(s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return true end
	local opt=0
	if b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(id,0))
	end
	if opt==0 or opt==2 then
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(800)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end
	if opt==1 or opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if d>0 then
		Duel.Damage(p,d,REASON_EFFECT)
	end
	if tc and s.dfilter(tc) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end