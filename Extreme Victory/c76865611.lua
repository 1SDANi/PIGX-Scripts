--D・ライトン
--Morphtronic Lantron
local s,id=GetID()
function s.initial_effect(c)
	--reflect battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(s.aval)
	c:RegisterEffect(e1)
	--reflect effect damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REFLECT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.dcon)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.dval)
	c:RegisterEffect(e2)
end
function s.aval(e)
	if e:GetHandler():IsAttackPos() then return 1 else return 0 end
end
function s.dcon(e)
	return e:GetHandler():IsDefensePos()
end
function s.dval(e,re,val,r,rp,rc)
	return (r&REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end