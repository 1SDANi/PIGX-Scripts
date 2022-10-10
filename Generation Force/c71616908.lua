--ジェムナイト・アメジス
--Gem-HERO Amethyst
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,false,false,27126980,s.fusfilter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--Attack while in defense position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.thcn)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={0x34,0x8}
s.material_setcode={0x34,0x8}
function s.thcn(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetPreviousLocation()&LOCATION_ONFIELD)~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if g and #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.fusfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_UNION) and c:IsLevelAbove(5)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end