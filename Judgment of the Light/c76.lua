--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=76
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
		19113101,45118716,72502414,8091563,45496268,71880877,8875971,44273680,70668285,7152333,33551032,70546737,6930746,5818294,32202803,94096616,94973028,20368763,93751476,28201945,54706054,27189308,
		14306092,13183454,77799846,74728028,1127737,37511832,904185,31677606,94156050,31554054,94933468,30338466,66727115,93211810,66604523,80555062
	}
	pack[2]={
		6330307,33725002,68601507,31480215,66762372,66540884,92039899,28423537,55428242,91812341,89856523,52639377,52639377,2061963,73906480,63883999,67949763,89732524,15721123,14005031
	}
	pack[3]={
		29146185,88033975,5288597,53550467,53550467,42216237,41517789,80978111,16366810,68661341,28493337,11066358,69723159,80190753,53451824,15240238,15028680,40390147,76067258,1249315,36499284,
		29616929,66413481,87911394,49456901,32339440,67489919,53573406,92099232,16943770,42338879,78610936,67136033,75840616,48333324,40908371,41620959,88241506,13513663,87025064,14235211,68371799,
		501000018,501000019,86308219,50903514,450000130,85463083,92609670,81587028,16037007,53244294,16259549,80764541,54366836,88754763,14152862,41147577,77631175,13030280,40424929,76419637,3814632,
		49202331,75797046,75574498,847915,94766498,20154092,67559101,93543806,20032555,56427559,92821268,29216967,55204071,28194325,54582424,27971137,89642993,42421606,89516305,15914410,41309158,
		2191144,38180759,1969506,37364101,74852810,37241623,63630268
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
