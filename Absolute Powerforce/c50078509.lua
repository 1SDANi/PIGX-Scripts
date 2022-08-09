--デモンズ・チェーン
--Demon Chain
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--negate effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
end