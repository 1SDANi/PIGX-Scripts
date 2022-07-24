--氷弾使いレイス
--Reese, Mage of the Ice Barrier
local s,id=GetID()
function s.initial_effect(c)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.dircon)
	e2:SetTarget(aux.TRUE)
	c:RegisterEffect(e2)
end
s.listed_series={0x2f}
function s.dircon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x2f),e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end