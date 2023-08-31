--エルシャドール・シェキナーガ
--El Shaddoll Shekhinaga
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x9d),s.matfilter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.aclimit1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.aclimit2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(s.elimit)
	c:RegisterEffect(e4)
end
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_MONSTER)and c:IsSummonType(SUMMON_TYPE_SPECIAL)) then return end
	e:GetHandler():RegisterFlagEffect(id+rp,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_CONTROL+RESET_PHASE+PHASE_END,0,1)
end
function s.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL)) then return end
	e:GetHandler():ResetFlagEffect(id+rp)
end
function s.elimit(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and e:GetHandler():GetFlagEffect(id+te:GetHandler():GetControler())~=0
end
s.listed_series={0x9d}
s.material_setcode=0x9d
function s.matfilter(c,lc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH,lc,sumtype,tp)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end