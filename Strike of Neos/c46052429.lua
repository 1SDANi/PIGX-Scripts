--高等儀式術
--Advanced Ritual Art
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	c:RegisterEffect(e1)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_HAND,0)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.ReleaseRitualMaterial(mat)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_DECK+LOCATION_HAND) and (c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_DECK))) and c:IsCanBeRitualMaterial()
end
