--迷犬マロン
--Outstanding Dog Marron
local s,id=GetID()
function s.initial_effect(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.reccon)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_COST)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(s.thcon)
		e1:SetTarget(s.thtg)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end