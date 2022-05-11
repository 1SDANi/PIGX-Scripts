--デストラクト・サークル－A
--Ring of Destruction "A"
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,PLAYER_ALL,aux.FilterBoolFunction(Card.GetCounter,COUNTER_A),nil,s.cost)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and
		Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and Duel.GetTurnPlayer()==tp end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetEquipTarget() and s.filter(e:GetHandler():GetEquipTarget()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		local val=Duel.Damage(tp,atk,REASON_EFFECT)
		local val=Duel.Damage(1-tp,atk,REASON_EFFECT)
		Duel.RDComplete()
	end
end
