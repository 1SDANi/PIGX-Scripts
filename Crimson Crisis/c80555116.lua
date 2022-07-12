--ナチュル・ガーディアン
--Naturia Guardian
local s,id=GetID()
function s.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetCost(aux.CostWithReplace(s.cost,CARD_NATURIA_CAMELLIA))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,c) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,c)
	Duel.Release(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not eg then return false end
	local tc=eg:GetFirst()
	if chkc then return chkc==tc end
	if chk==0 then return ep~=tp and tc:IsFaceup() and tc:GetAttack()>=1000 and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>=1000 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end