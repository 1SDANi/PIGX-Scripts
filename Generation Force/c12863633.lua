--五稜星の呪縛
--Curse of the Circle
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Cannot be tributed
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(3303)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	--Cannot be used as fusion material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(3309)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end