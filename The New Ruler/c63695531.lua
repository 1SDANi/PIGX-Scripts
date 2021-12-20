--墓守の長槍兵
--Gravekeeper's Spearman
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FLIP+EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCondition(s.eqcon)
	e2:SetValue(s.valcon)
	c:RegisterEffect(e2)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetHandler() and e:GetHandler():GetBattlePosition()==POS_FACEDOWN_DEFENSE
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and e:GetHandler()==Duel.GetAttackTarget() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and e:GetHandler()==Duel.GetAttackTarget() then
		Duel.Destroy(Duel.GetAttacker(),REASON_EFFECT)
	end
end