--グランド・スパイダー
--Ground Spider
local s,id=GetID()
function s.initial_effect(c)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.filter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and g and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,#eg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil)
	if e:GetHandler():IsRelateToEffect(e) and g and #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
	end
end
