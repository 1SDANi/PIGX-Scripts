--ロード・オブ・ドラゴン－ドラゴンの支配者－
--Lord of Dragons
local s,id=GetID()
function s.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.etarget)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(s.ccon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
end
function s.etarget(e,c)
	return c:IsRace(RACE_DRAGON)
end
function s.ccon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_DRAGON),tp,LOCATION_MZONE,0,1,nil,RACE_DRAGON)
end
