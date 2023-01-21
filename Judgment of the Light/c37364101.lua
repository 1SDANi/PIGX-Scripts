--ストイック・チャレンジ
--Stoic Challenge
local s,id=GetID()
function s.initial_effect(c)
	--Atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(s.value)
	c:RegisterEffect(e0)
	--Double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetCondition(s.dcon)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
end
function s.dcon(e)
	return Duel.GetAttackTarget()==e:GetHandler():GetEquipTarget() or Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function s.value(e,c)
	return c:GetCounter(COUNTER_XYZ)*500
end