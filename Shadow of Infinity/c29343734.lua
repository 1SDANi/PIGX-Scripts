--E・HERO エリクシーラー
--Elemental HERO Elixir
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.filter1,1,s.filter2,4)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.effcon)
	c:RegisterEffect(e0)
	--Type Warrior
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_ALL)
	e1:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e1)
	--Attribute Materials
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ALL)
	e2:SetValue(s.attval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(s.tglimit)
	c:RegisterEffect(e3)
	--Register effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.regcon)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end
s.material_race=RACE_WARRIOR
s.material_attribute={ATTRIBUTE_LIGHT}
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	if mat:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0 then
		--cannot be target
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(aux.tgoval)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if mat:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0 then
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(s.indtg)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		--intar
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(s.indtg)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		--cannot activate
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetCondition(s.econ)
		e3:SetValue(s.efilter)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if mat:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0 then
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		e2:SetValue(s.valcon)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if mat:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0 then
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.val)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
function s.val(e,c)
	local boost = 0
	if e:GetHandler():IsAttribute(ATTRIBUTE_EARTH) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_EARTH),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	if e:GetHandler():IsAttribute(ATTRIBUTE_FIRE) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_FIRE),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	if e:GetHandler():IsAttribute(ATTRIBUTE_WATER) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_WATER),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	if e:GetHandler():IsAttribute(ATTRIBUTE_WIND) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_WIND),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	if e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	if e:GetHandler():IsAttribute(ATTRIBUTE_DARK) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_DARK),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	if e:GetHandler():IsAttribute(ATTRIBUTE_DIVINE) and
		Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_DIVINE),c:GetControler(),0,LOCATION_MZONE,nil)>0
			then boost = boost + 1000 end
	return boost
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end
function s.fieldfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function s.econ(e)
	return Duel.IsExistingMatchingCard(s.fieldfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.efilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.indtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD)
end
function s.tglimit(e,c)
	return c and c:IsAttribute(e:GetHandler():GetAttribute())
end
function s.attval(e,c)
	local att=0
	local og=e:GetHandler():GetMaterial()
	for tc in aux.Next(og) do
		att=att|tc:GetAttribute()
	end
	return att
end
function s.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function s.filter1(c,fc,sumtype,tp)
	return (c:IsRace(RACE_WARRIOR,fc,sumtype,tp) and (c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp)))
end
function s.filter2(c,fc,sumtype,tp)
	return (c:IsRace(RACE_WARRIOR,fc,sumtype,tp) and not (c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end