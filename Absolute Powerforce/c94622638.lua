--A・ジェネクス・パワーコール
--Genex Ally Powercell
local s,id=GetID()
function s.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.costg)
	e2:SetOperation(s.cosop)
	c:RegisterEffect(e2)
end
function s.atktg(e,c)
	return c~=e:GetHandler() and e:GetHandler():IsAttribute(c:GetAttribute())
end
function s.costg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
	local att=aux.AnnounceAnotherAttribute(e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	e:SetLabel(att)
end
function s.cosop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler() and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	end
end
