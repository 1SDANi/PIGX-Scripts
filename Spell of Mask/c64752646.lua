--ビッグバンガール
--Princess of Hell
local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCondition(s.cn)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,ev/4,REASON_EFFECT)
end
