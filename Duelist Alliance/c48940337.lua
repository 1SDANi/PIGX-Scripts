--ランスフォリンクス
--Lancephorhynchus
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--union place
	local eUnionPlace=Effect.CreateEffect(c)
	eUnionPlace:SetDescription(aux.Stringid(id,0))
	eUnionPlace:SetType(EFFECT_TYPE_IGNITION)
	eUnionPlace:SetRange(LOCATION_HAND)
	eUnionPlace:SetCountLimit(1)
	eUnionPlace:SetTarget(s.settg)
	eUnionPlace:SetOperation(s.setop)
	c:RegisterEffect(eUnionPlace)
	--union summon
	local eUnionSummon=Effect.CreateEffect(c)
	eUnionSummon:SetType(EFFECT_TYPE_FIELD)
	eUnionSummon:SetRange(LOCATION_SZONE)
	eUnionSummon:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	eUnionSummon:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	eUnionSummon:SetDescription(aux.Stringid(id,1))
	eUnionSummon:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_UNION))
	c:RegisterEffect(eUnionSummon)
	--summon with continuous spells
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.AND(aux.TargetBoolFunction(Card.IsType,TYPE_CONTINUOUS),aux.TargetBoolFunction(Card.IsType,TYPE_SPELL)))
	e0:SetValue(POS_FACEUP)
	c:RegisterEffect(e0)
	--Piercing
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(aux.IsGeminiState)
	e1:SetTarget(aux.TRUE)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.IsGeminiState)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsCanChangePosition() and c:IsPosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSITION)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
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