--エクシーズ・オーバーライド
--Xyz Override
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Remove counter replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_RCOUNTER_REPLACE+COUNTER_XYZ)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.rcn)
	e3:SetOperation(s.rop)
	c:RegisterEffect(e3)
end
function s.rcn(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_COST)~=0 and Duel.CheckReleaseGroupCost(tp,aux.TRUE,ev,true,nil,nil,tp) and re:GetHandler()~=e:GetHandler()
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroupCost(tp,aux.TRUE,ev,ev,true,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end