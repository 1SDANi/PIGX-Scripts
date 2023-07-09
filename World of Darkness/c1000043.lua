--Super Fusion God
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,false,true,true,s.fusfilter,1,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION,nil,nil,nil,nil,nil,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.effcon)
	c:RegisterEffect(e0)
	--to deck
	local e00=Effect.CreateEffect(c)
	e00:SetDescription(aux.Stringid(id,0))
	e00:SetCategory(CATEGORY_TODECK)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e00:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetTarget(s.rtdtg)
	e00:SetOperation(s.rtdop)
	c:RegisterEffect(e00)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--def
	local e01=e1:Clone()
	e01:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e01)
	--extra attacks
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(s.count)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(s.dircon)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(s.actlimit)
	e4:SetCondition(s.actcon)
	c:RegisterEffect(e4)
	--cannot target for attacks
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.condtion)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	--no damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CHANGE_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCondition(s.condition)
	e6:SetTargetRange(1,0)
	e6:SetValue(s.damval)
	c:RegisterEffect(e6)
	local e06=e6:Clone()
	e06:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e06)
	local e006=e6:Clone()
	e006:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e006)
	local e0006=Effect.CreateEffect(c)
	e0006:SetType(EFFECT_TYPE_SINGLE)
	e0006:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e0006:SetCondition(s.condition)
	e0006:SetValue(1)
	c:RegisterEffect(e0006)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e7:SetCountLimit(1)
	e7:SetCondition(s.cn)
	e7:SetValue(s.valcon)
	c:RegisterEffect(e7)
	--cannot be target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.ctlcon)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	--Negate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,1))
	e9:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(s.negcn)
	e9:SetTarget(s.negtg)
	e9:SetOperation(s.negop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetCode(EFFECT_CANNOT_SUMMON)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,1)
	e10:SetTarget(s.sumlimit)
	c:RegisterEffect(e10)
	local e010=e10:Clone()
	e010:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e010)
	--destroy
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,2))
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTarget(s.destg)
	e11:SetOperation(s.desop)
	c:RegisterEffect(e11)
	--win
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,3))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e12:SetCode(EVENT_BATTLE_DAMAGE)
	e12:SetCondition(s.atkcon)
	e12:SetOperation(s.atkop)
	c:RegisterEffect(e12)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,WIN_REASON_DUEL_WINNER)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mat=e:GetHandler():GetMaterial()
	if chk==0 then return mat and (#mat)>=11 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=10
end
function s.negcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=9 and Duel.IsChainNegatable(ev) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.ctlcon(e)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=8
end
function s.cn(e,tp)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=7
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end
function s.condition(e,tp)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=6
end
function s.damval(e,re,val,r,rp,rc)
	if (r&REASON_EFFECT)~=0 or (r&REASON_BATTLE)~=0 then return 0
	else return val end
end
function s.condtion(e)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=5
end
function s.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end
function s.actcon(e)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=4 and Duel.GetAttacker()==e:GetHandler()
end
function s.dircon(e)
	local mat=e:GetHandler():GetMaterial()
	return mat and (#mat)>=3
end
function s.val(e,c)
	local g=e:GetHandler():GetMaterial()
	return #g*1000
end
function s.count(e,c)
	local g=e:GetHandler():GetMaterial()
	return #g-1
end
function s.rtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.rtdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
function s.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function s.fusfilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsType(TYPE_MONSTER+TYPE_UNION) and c:HasLevel() and c:IsLevelBelow(12) and ((not sg) or (not sg:IsExists(Card.IsLevel,1,c,c:GetLevel())))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
end
function s.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end