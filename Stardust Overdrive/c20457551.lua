--鋼核収納
--Iron Core Chimera Core Armor
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end