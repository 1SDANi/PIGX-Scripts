--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=68
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
		62476815,98865920,25259669,98649372,24137081,87526784,50319138,23915499,12299841,12076263,84569017,11954712,19019586,46404281,9897998,45282603,71786742,8175346,34160055,71564150,94770493,
		20264508,7653207,69042950,32835363,69320362,32703716,64107820,90592429,90470931,99657399,25642998,52140003,98535702,24920410,51324455,50292967,86690572,13685271,59070329,48357738,97896503,
		24291651,50785356,86174055,59563768,23168060,86952477,11224934,58628539,85839825,58441120,22346472,33017655,69402394,45662855,72056560,8041569,11834972,47228077,84313685,72439556,46044841,
		19959742,91822647,64437633,38049934,1644289,39261576
	}
	pack[2]={
		69572169,24103628,21143940,51254277,50532786,59297550,58475908,47349310,84747429,10132124,72403299,33347467,63485233,26864586,87313164,24707869,86474024,12863633,85352446,22842214,21507589,
		57902193,58147549,19163116,45439263,10712320,73551138,9837195,65659181
	}
	pack[3]={
		31386180,95231062,21620076,68124775,94119480,93396832,45170821,37926346,6836211,33225925,52263685,48135190,96457619,26082117,86804246,85682655,73625877,7953868,70832512,33057951,5014629,6430659,
		95714077,27980138,46759931,10920352,67775894,11741041,47126872,32003338,68597372,95992081,69846323,1945387,8949584,69610924,10002346,47506081,84013237,35952884,71341529,7845138,56410040,43096270,
		49674183,45298492,6602300,39284521,78082039,69069911,34796454,7392745,61807040,60181553,97170107,60228941,34230233,45222299,71616908,8611007,34109611,71594310,3989465,39987164,76372778,2766877,
		501000014,501000015
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
