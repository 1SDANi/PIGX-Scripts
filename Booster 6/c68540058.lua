--メタル化・魔法反射装甲
--Metalmorph
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(s.atkcon)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
end
function s.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and Duel.GetAttackTarget()
end
function s.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()/2
end
