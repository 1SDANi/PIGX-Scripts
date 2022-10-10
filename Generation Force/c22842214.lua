--シー・ランサー
--Sea Lancer
local s,id=GetID()
function s.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e1)
end
function s.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsRace(RACE_AQUATIC)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUATIC) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_REMOVED,0,1,fc,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function s.equipop(c,e,tp,tc,chk)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,id) then return false end
	return true
end
function s.repval(e,re,r,rp)
	return r&REASON_BATTLE~=0 or r&REASON_EFFECT~=0
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local tg=Group.CreateGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if ft>=#g then
			tg:Merge(g)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			tg:Merge(g:Select(tp,ft,ft,nil))
		end
	end
	g:Sub(tg)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and s.equipop(c,e,tp,tc) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(s.repval)
			tc:RegisterEffect(e2)
			--atk up
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(1000)
			tc:RegisterEffect(e3)
		end
	end
	Duel.EquipComplete()
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
end