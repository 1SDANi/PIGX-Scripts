--火之迦具土
--Hi-No-Kagutsuchi
local s,id=GetID()
function s.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(s.hdcon)
	e4:SetOperation(s.hdreg)
	c:RegisterEffect(e4)
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():GetControler()==tp and eg:GetFirst():IsType(TYPE_SPIRIT)
end
function s.hdreg(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetOperation(s.hdop)
	Duel.RegisterEffect(e1,tp)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)
	end
end
