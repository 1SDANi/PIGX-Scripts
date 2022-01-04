--閃光の双剣－トライス
--Lightning Blades - Tryce
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,s.cost)
	--Atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Double Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end