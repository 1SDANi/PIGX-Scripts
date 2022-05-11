--魔性の月
--Soul Devouring Bamboo Sword
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,s.eqfilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.cn)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_series={0x60}
function s.eqfilter(c)
	return c:GetEquipCount()~=0 and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x60)
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsContains(ec) and ep~=tp
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.hdcon)
	e1:SetTarget(s.hdtg)
	e1:SetOperation(s.hdop)
	if p==tp then 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,p)
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==ep and Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0
end
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,ep,1)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	if #g>0 then
		local sg=g:RandomSelect(ep,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end