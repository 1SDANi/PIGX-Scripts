--墓守の従者
--Gravekeeper's Vassal
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
	e1:SetType(EFFECT_TYPE_FIELD)
	if p==tp then
		e1:SetTargetRange(LOCATION_MZONE,0)
	elseif p==tp then
		e1:SetTargetRange(0,LOCATION_MZONE)
	elseif p==PLAYER_ALL then
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	elseif p==PLAYER_NONE then
		e1:SetTargetRange(0,0)
	else
		Debug.Message("ERROR! Gravekeeper's Vassal targeted player" + tostring(p))
	end
	Duel.RegisterEffect(e1,p)
end