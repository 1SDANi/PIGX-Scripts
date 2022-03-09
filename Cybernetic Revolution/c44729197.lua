--スチームロイド
--Steamroid
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and t:IsControler(1-tp) end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	e:SetLabel(op)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	if not (a and a==e:GetHandler() and t) then return end
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(500)
		a:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		a:RegisterEffect(e2)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_SWAP_BASE_AD)
		e1:SetRange(LOCATION_MZONE)
		a:RegisterEffect(e1)
		local e2=e1:Clone()
		t:RegisterEffect(e2)
	end
end