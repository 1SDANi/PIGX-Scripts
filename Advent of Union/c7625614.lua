--レアゴールド・アーマー
--Raregold Armor
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,nil,s.eqlimit)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(s.ccon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
end
function s.ccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end