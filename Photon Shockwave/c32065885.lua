--痛恨の訴え
--Heartfelt Appeal
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.ctlcon)
	e1:SetTarget(s.ctltg)
	e1:SetOperation(s.ctlop)
	c:RegisterEffect(e1)
end
function s.ctlcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetAttackTarget()==nil and Duel.GetAttacker():IsControler(1-tp)
end
function s.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:IsDefenseAbove(0)
end
function s.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function s.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	local sg=g:GetMaxGroup(Card.GetDefense)
	if #sg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	end
	local tc=sg:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
end
