--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=70
if self_code then id=self_code end
if not SealedDuel then
	SealedDuel={}
	local function finish_setup()
		--Pre-draw
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetCountLimit(1)
		e1:SetOperation(SealedDuel.op)
		Duel.RegisterEffect(e1,0)
	end
	--define pack
	--pack[1]=BP01, [2]=BP02, [3]=BPW2, [4]=BP03
	--[1]=common, [2]=rare, [3]=foil
	pack={}
	pack[1]={
		40817915,76202610,2584136,1362589,38757297,64145892,22812068,96427353,33034646,69023354,95395761,21790410,21977828,93451636,20855340,69633792,23234094,22512406,58911105,95905259,20277376,
		21390858,81000306,44883600,80887714,43661068,77098449,78933589,30600344,41722932,30488793,39765115,65150219,64038662,91422370,37421075,64815084,52971944,25206027,51589188,16796157,43791861,
		79185500,42969214,18063928,45458027,81846636,16906241,43513897,17129783,70624184,44635489,5284653,4058065,78663366,42679662,64662453,27541267,90156158,90934570,63545861,80208158
	}
	pack[2]={
		39695323,76080032,38973775,65367484,90640901,68184115,56240989,57784563,17494901,42548470,4215636,76972801,38643567,63193536,26586849,52601736,24362891,50766506,80208158,15574615,17241370,
		42391240,70908596,79785958,77841719,31456110
	}
	pack[3]={
		3606728,44505297,26708437,99212922,52823314,77334267,4423206,94283662,83061014,3493058,99188141,87973893,69207766,57962537,57662975,82944432,16272453,79155167,5338223,78811937,2148918,90200789,
		25484449,88095331,94573223,95027497,29455728,19333131,55727845,81122844,18511599,16550875,2371506,56840427,51735257,26329679,65737274,66853752,67675300,3070049,30464153,30587695,77797992,4192696,
		31303283,43813459,17418745,44035031,81146288,19353570,55758589,10000030,25460258,51858306,99365553,20638610,94243005,3113836,30334522,66729231,66506689,2091298,65884091,91279700,4335427,39512984,
		38495396,38273745
	}
	for _,v in ipairs(pack[1]) do table.insert(pack[3],v) end
	for _,v in ipairs(pack[2]) do table.insert(pack[3],v) end
	function SealedDuel.op(e,tp,eg,ep,ev,re,r,rp)
		for _,card in ipairs(selfs) do
			Duel.SendtoDeck(card,0,-2,REASON_RULE)
		end
		local counts={}
		counts[0]=Duel.GetPlayersCount(0)
		counts[1]=Duel.GetPlayersCount(1)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_CARD,0,id)
		--tag variable defining
		local z,o=tp,1-tp
		if not aux.AskEveryone(aux.Stringid(id,1)) then
			return
		end
		
		local groups={}
		groups[0]={}
		groups[1]={}
		for i=1,counts[0] do
			groups[0][i]={}
		end
		for i=1,counts[1] do
			groups[1][i]={}
		end
		for p=z,o do
			for team=1,counts[p] do
				for i=1,15 do
					local packnum=1
					for i=1,6 do
						local rarity
						if i==4 or i==5 then
							rarity=2
						elseif i<6 then
							rarity=1
						else
							rarity=Duel.GetRandomNumber(1,3)
						end
						local code
						code=pack[rarity][Duel.GetRandomNumber(1,#pack[rarity])]
						table.insert(groups[p][team],code)
					end
				end
			end
		end
		
		for p=z,o do
			for team=1,counts[p] do
				Duel.SendtoDeck(Duel.GetFieldGroup(p,0xff,0),nil,-2,REASON_RULE)
				for idx,code in ipairs(groups[p][team]) do
					Debug.AddCard(code,p,p,LOCATION_DECK,1,POS_FACEDOWN_DEFENSE)
				end
				Debug.ReloadFieldEnd()
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,2))
				local fg=Duel.GetFieldGroup(p,0xff,0)
				local extra=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
				local exclude=fg:Select(p,#fg-60-#extra,#fg-60-#extra,nil)
				if exclude then
					Duel.SendtoDeck(exclude,nil,-2,REASON_RULE)
				end
				Duel.ShuffleDeck(p)
				Duel.ShuffleExtra(p)
				if counts[p]~=1 then
					Duel.TagSwap(p)
				end
			end
		end
	end
	finish_setup()
end
if not Duel.GetStartingHand then
	Duel.GetStartingHand=function() return 5 end
end
