--ご隠居の猛毒薬
--Poison of the Old Man
local s,id=GetID()
function s.initial_effect(c)
	--rec or dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	e:SetLabel(op)
	if op==0 or op==2 then
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	end
	if op==1 or op==2 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or e:GetLabel()==2 then
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
	if e:GetLabel()==1 or e:GetLabel()==2 then
		Duel.Damage(1-tp,500,REASON_EFFECT) 
	end
end

