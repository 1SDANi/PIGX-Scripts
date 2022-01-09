--堕落
--Falling Down
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,1,aux.CheckStealEquip,s.eqlimit,nil,s.target)
	--selfdestroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.sdtg)
	e5:SetOperation(s.sdop)
	c:RegisterEffect(e5)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetValue(s.ctval)
	c:RegisterEffect(e5)
end
s.listed_names={35975813}
function s.sdfilter1(c)
	return c:IsCode(35975813) and c:IsFaceup()
end
function s.sdfilter2(c,e,tp)
	return c:IsCode(35975813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(s.sdfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)>0 and
		Duel.IsExistingMatchingCard(s.sdfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Duel.SelectMatchingCard(tp,s.sdfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function s.target(e,tp,eg,ep,ev,re,r,rp,tc,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.ctval(e,c)
	return e:GetHandlerPlayer()
end
