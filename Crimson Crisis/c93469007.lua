--バスター・バースト
--Assault Overload
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x104f}
function s.filter(c)
	return c:IsSetCard(0x104f) and c:IsFaceup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.filter,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.filter,1,1,false,nil,nil)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(eg:GetFirst():GetAttack())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	if atk<0 then atk=0 end
	Duel.Damage(tp,atk,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end