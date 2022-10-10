--スカル・クラーケン
--Skull Kraken
local s,id=GetID()
function s.initial_effect(c)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tg=Group.CreateGroup()
	tg:AddCard(g:GetFirst())
	tg:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,#tg,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 and Duel.Remove(c,c:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e2:SetCountLimit(1)
		e2:SetCondition(s.retcon)
		e2:SetOperation(s.retop)
		e2:SetLabelObject(c)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
