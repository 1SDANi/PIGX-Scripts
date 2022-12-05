--魔導老士 エアミット
--L'Hermite the Magical Wizard
local s,id=GetID()
function s.initial_effect(c)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--def down
	local e22=e2:Clone()
	e22:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e22)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetOwnerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*-100
end