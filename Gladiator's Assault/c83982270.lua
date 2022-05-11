--雲魔物－ポイズン・クラウド
--Cloudian - Poison Cloud
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
s.counter_list={COUNTER_FOG}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	if chk==0 then return bc and bc:GetCounter(COUNTER_FOG)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	if bc and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end