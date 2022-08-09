--ブラックポータン
--Black Potan
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(s.target)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
end
function s.filter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and
		c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsPreviousControler(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,e,tp)
	if chk==0 then return g and #g~=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
