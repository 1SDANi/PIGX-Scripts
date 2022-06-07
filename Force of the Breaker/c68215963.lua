--宝玉獣 エメラルド・タートル
--Crystal Beast Emerald Tortoise
local s,id=GetID()
function s.initial_effect(c)
	--Destroy replace
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(s.desreptg)
	e0:SetOperation(s.desrepop)
	c:RegisterEffect(e0)
	--Change position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(s.poscon)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	--change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
s.listed_series={0x1034}
function s.filter(c)
	return c:IsAttackPos()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSITION)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	local crystala = (a:IsControler(tp) and a:IsType(TYPE_UNION) and a:IsSetCard(0x1034))
	local crystalt = (t and t:IsControler(tp) and t:IsType(TYPE_UNION) and t:IsSetCard(0x1034))
	return (crystala or crystalt) and 
		((a:IsAttackPos() and a:IsLocation(LOCATION_MZONE)) or (t and t:IsAttackPos() and t:IsLocation(LOCATION_MZONE)))
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if t and t:IsAttackPos() and t:IsLocation(LOCATION_MZONE) then
		Duel.ChangePosition(t,POS_FACEUP_DEFENSE)
	end
	if a:IsAttackPos() and a:IsLocation(LOCATION_MZONE) then
		Duel.ChangePosition(a,POS_FACEUP_DEFENSE)
	end
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return
	else 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS+TYPE_UNION)
		e:GetHandler():RegisterEffect(e1)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end