--クリフォート・シェル
--Qliphort Shell
local s,id=GetID()
function s.initial_effect(c)
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
	eUnionSummon:SetDescription(aux.Stringid(id,1))
	eUnionSummon:SetCategory(CATEGORY_SUMMON)
	eUnionSummon:SetType(EFFECT_TYPE_IGNITION)
	eUnionSummon:SetRange(LOCATION_SZONE)
	eUnionSummon:SetCountLimit(1)
	eUnionSummon:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,typing=TYPE_UNION})
	eUnionSummon:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,typing=TYPE_UNION})
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
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	e1:SetOperation(s.ntop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(s.qliop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(s.cn)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e2)
end
function s.qliop(e,tp,eg,ep,ev,re,r,rp)
	--Unaffected by monster effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(3111)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.efilter)
	e:GetHandler():RegisterEffect(e1)
end
function s.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(4)
	c:RegisterEffect(e2)
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