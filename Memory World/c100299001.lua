--幻惑の眼
--Eye of Illusion
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHIC))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()==Duel.GetAttacker() and Duel.GetAttackTarget()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget() and Duel.GetAttackTarget():IsControler(1-tp) and Duel.GetAttackTarget():IsControlerCanBeChanged() and Duel.GetAttackTarget():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,Duel.GetAttackTarget(),1,0,0)
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget() and not Duel.GetAttackTarget():IsFacedown() then
		local tct=2
		if Duel.GetTurnPlayer()~=tp then tct=1 elseif Duel.GetCurrentPhase()==PHASE_STANDBY then tct=3 end
		if Duel.GetControl(Duel.GetAttackTarget(),tp,PHASE_STANDBY,tct) then
			--negate effect
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			Duel.GetAttackTarget():RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			Duel.GetAttackTarget():RegisterEffect(e2)
			--at limit
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(0,LOCATION_MZONE)
			e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e3:SetValue(s.atlimit)
			e3:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			Duel.GetAttackTarget():RegisterEffect(e3)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.GetAttackTarget():RegisterEffect(e4)--Cannot be tributed
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetDescription(3303)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCode(EFFECT_UNRELEASABLE_SUM)
			e5:SetValue(1)
			e5:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			Duel.GetAttackTarget():RegisterEffect(e5,true)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			Duel.GetAttackTarget():RegisterEffect(e6,true)
			--Cannot be used as fusion material
			local e7=Effect.CreateEffect(e:GetHandler())
			e7:SetDescription(3309)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e7:SetRange(LOCATION_MZONE)
			e7:SetValue(1)
			e7:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			Duel.GetAttackTarget():RegisterEffect(e7,true)
		end
	end
end