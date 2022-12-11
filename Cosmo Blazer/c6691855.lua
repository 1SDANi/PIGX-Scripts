--鎖付き尖盾
--Spikeshield with Chain
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c:GetAttack())
	c:RegisterEffect(e2)
end