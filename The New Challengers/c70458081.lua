--EMジンライノ
--Peformapal Thunderhino
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
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.target)
	c:RegisterEffect(e2)
end
function s.target(e,c)
	return c:IsFaceup() and e:GetHandler():GetColumnGroup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(e:GetHandler(GetControler())) and not e:GetHandler():GetColumnGroup():IsContains(c)
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