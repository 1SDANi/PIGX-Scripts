--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=57
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
		92720564,40348946,2986553,42035044,47754278,63665875,97651498,97439806,97439806,23927545,36717258,99150062,25654671,98437424,24432029,51827737,20700531,56704140,82199284,82377606,54860010,
		17649753,40619825,26412047,85852291,25774450,84808313,66518841,14730606,5616412,4206964,75014062,39910367,96553688,41160533,59042331,85431040,58820853,85215458,84592800,10591919,47985614,
		45041488,80925836,43708640,16191953,42685062,79080761,15475415,42463414,4252828,41741922,77135531,38680149,65079854,38568567,90239723,63018036,37745919,63730624,99002135,25401880,62896588,
		97168905,24566654,50951359,87046457,23440062,86223870,22628574,59616123,85101228,11596936,58990631,11373345
	}
	pack[2]={
		23303072,31829185,15894048,60434101,59312550,61049315,29587993,28465301,45247637,37132349,64627453,90011152,71759912,91133740,50164989,22835145,57108202,83370323,54520292,17313545,78868119,
		2295440,64952266,36623431,51773900,94878265,56535497,76714458,91133740,71759912,37132349,64627453,90011152,21672573
	}
	pack[3]={
		85087012,24040093,62701967,93211836,81254059,16527176,54048462,80032567,43925870,89310929,76137614,2525268,40732515,69695704,32485518,68473226,67757079,20140382,25132288,46609443,82693042,
		4130270,98380593,47778083,46656406,51987571,97385276,23558733,19642889,80102359,76913983,76891401,1073952,59839761,10651797,95090813,21362970,94145683,23770284,11613567,12435193,86016245,
		10875327,46263076,40529384,39402797,25789292,83266092,2403771,85771019,62782218,26293219,99899504,63804806,98954375,51566770,99177923,25171661,11260714,9666558,71971554,50621530,2322421,13504844,
		25862681,42024143,501000010,501000011
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
