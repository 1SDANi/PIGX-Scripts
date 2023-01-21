--武神器－ムラクモ
--Bujingi Quilin
local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	if chk==0 then return bc and tc:IsFaceup() and tc:IsRace(RACE_BEAST) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t==e:GetHandler() then t=Duel.GetAttacker() end
	if t and t:IsRelateToBattle() then
		Duel.Destroy(t,REASON_EFFECT)
	end
end