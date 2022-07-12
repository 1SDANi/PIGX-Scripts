--F・G・D
--Five-Headed Dragon God
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,true,true,s.filter1,1,s.filter2,4)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.effcon)
	c:RegisterEffect(e0)
	--Type Dragon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_ALL)
	e1:SetValue(RACE_DRAGON)
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
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.regcon)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
end
s.material_race=RACE_DRAGON
s.material_attribute={ATTRIBUTE_DARK}
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
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCountLimit(1)
		e1:SetTarget(s.destg)
		e1:SetOperation(s.desop)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if mat:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0 then
		--damage
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,5))
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(s.damcon)
		e1:SetTarget(s.damtg)
		e1:SetOperation(s.damop)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if mat:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0 then
		--extra attack
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(s.atcon)
		e1:SetOperation(s.atop)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():CanChainAttack(0)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc:IsType(TYPE_MONSTER) and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
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
	return (c:IsRace(RACE_DRAGON,fc,sumtype,tp) and (c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)))
end
function s.filter2(c,fc,sumtype,tp)
	return (c:IsRace(RACE_DRAGON,fc,sumtype,tp) and not (c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp)))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end