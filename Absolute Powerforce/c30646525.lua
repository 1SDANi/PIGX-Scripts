--破滅の魔王ガーランドルフ
--Verdict, Knight of Torment
local s,id=GetID()
function s.initial_effect(c)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.rmtarget)
	e2:SetTargetRange(0,0xff)
	e2:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e2)
end
function s.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetOwner()~=1-e:GetHandler():GetControler()
end