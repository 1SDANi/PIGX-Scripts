--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=51
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
		90582719,26976414,5592689,67159705,30042158,53927679,39829561,91596726,90464188,26254876,26046205,52035300,25924653,52248570,35011819,
		14702066,51196174,87685879,14089428,50074522,53461122,99865167,13857930,12735388,11913700,48017809,74402414,1896112,47295267,
		73567374,9952083,35956022,8730435,35224440,7617253,60406591,65384019,92773018,67045174,30834988,67223587,66100045,72237166,9622164
	}
	pack[2]={
		27869883,53257892,90642597,48130397,46173679,72345736,34002992,93895605,38167722,5562461,93217231,39712330,13314457,48686504,49808196,75081613,
		36931229,38247752,99747800,65743242
	}
	pack[3]={
		14536035,79407975,78371393,4779091,31764700,66214679,38107923,3657444,66436257,28985331,64379430,89529919,49352945,92719314,65192027,40921744,
		45462639,63665875,33655493,86346643,75524092,61623148,92595643,39980304,674561,31550470,76203291,12298909,79852326,88307361,73680966,4440873,
		76925842,1475311,34294855,26905245,71799173,19028307,11366199,1353770,9327502,10449150,46848859,92826944,8400623,48964966,74968065,57666212,
		21672573,9748752,36733451,30155789,67316075,3701074,70342110,17559367,44947065,15684835,89312388,26701483,52105192,88190790
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
