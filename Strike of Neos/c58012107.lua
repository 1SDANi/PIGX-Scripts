--エーリアン・サイコ
--Alien Psychic
local s,id=GetID()
function s.initial_effect(c)
	--cannot attack announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTarget(s.atktg)
	c:RegisterEffect(e3)
	--Pos limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e4:SetTarget(s.atktg)
	c:RegisterEffect(e4)
end
s.counter_list={COUNTER_A}
function s.atktg(e,c)
	return c:GetCounter(COUNTER_A)>0
end
