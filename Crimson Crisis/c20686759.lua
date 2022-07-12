--D・レトロエンジン
--Morphtronic Rusty Engine
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(EVENT_TO_GRAVE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetPreviousEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetPreviousEquipTarget()
	if tc then
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		Duel.Damage(tp,atk,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end