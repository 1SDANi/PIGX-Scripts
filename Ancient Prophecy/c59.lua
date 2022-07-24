--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=59
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
		14898066,49003716,63977008,71625222,4335645,89312388,73040500,46833854,8316661,45711266,8594079,70083723,7478431,70261145,6256844,1533292,65149697,38528901,90311614,37806313,30299166,67964209,
		76683171,12652643,35809262,70046172,71044499,76714458,94192409,28378427,29267084,77754944,73837870,10321588,46710683,45593005,7264861,70054514,6320631,31692182,68087897,20470500,93369354,8279188,
		20358953,62742651,98147766,51020079,98024118,87292536,50781944,98847704,25231813,51630558,24019261,59385322,50418970,12174035,49669730,85668449,48447192,46502013,73507661,9995766,72885174,
		35268887,71652522,34545235,60530944,7935043,33323657,60718396,95750695,68366996,6112401
	}
	pack[2]={
		63977008,19439119,71106375,44689688,32744558,64926005,3204467,98502113,97169186,36361633,47432275,72992744,34471458,71870152,34659866,6142213,68809475,95204084,25531465,23297235,86170989,
		86170989,86780027,98273947,8057630,78422252,77600660,77584012,6150044,37955049,41753322
	}
	pack[3]={
		102380,72328962,33866130,2088870,65961683,48976825,39477584,2956282,38354937,65749035,42024143,4694209,3972721,43378048,79473793,42256406,52512994,16304628,94081496,74845897,11830996,32207100,
		8487449,32314730,24419823,51808422,13574687,59969392,87624166,87902575,13997673,11052544,73729209,46480475,39967326,19028307,72714392,33537328,69931927,25958491,52352005,5817857,41201555,
		40189917,14258627,25862681,80367387,55690251,68450517,94845226,96872283,32271987,69488544,21249921,34116027,7841112,39037517,41181774
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
