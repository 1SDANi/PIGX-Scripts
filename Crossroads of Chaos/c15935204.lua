--ストーム・サモナー
--Storm Caller
local s,id=GetID()
function s.initial_effect(c)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.rmtarget)
	e3:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e3)
end
function s.rmtarget(e,c)
	return not c:IsType(TYPE_SPELL+TYPE_TRAP)
end

