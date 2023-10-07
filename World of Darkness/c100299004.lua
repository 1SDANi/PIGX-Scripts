--暗黒界の混沌王 カラレス
--Colorless, Demon God of Dark World
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,false,true,true,s.fil,3,99)
	Fusion.AddContactProc(c,s.contactfil1,s.contactop1,nil,nil,SUMMON_TYPE_FUSION)
	Fusion.AddContactProc(c,s.contactfil2,s.contactop2,nil,nil,SUMMON_TYPE_FUSION,nil,nil,nil,nil,nil,nil,LOCATION_GRAVE)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--def
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
s.listed_names={99458769,34230233}
s.material_setcode={0x6}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function s.val(e,c)
	local g=e:GetHandler():GetMaterial()
	return #g*1000
end
function s.godfil(c)
	return c:IsCode(99458769) or c:IsCode(34230233)
end
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsSetCard(0x6,fc,sumtype,tp) and c:IsType(TYPE_MONSTER+TYPE_UNION,fc,sumtype,tp) and (s.godfil(c) or (not sg or sg:IsExists(s.godfil,1,c)))
end
function s.contactfil1(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop1(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function s.contactfil2(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop2(g)
	Duel.SendtoHand(g,nil,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end