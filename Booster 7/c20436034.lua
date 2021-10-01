--磁力の指輪
--Ring of Magnetism
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,nil,s.eqlimit)
	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.tgtg)
	c:RegisterEffect(e3)
end
function s.tgtg(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end