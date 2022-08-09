--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=61
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
		72992744,41230939,50939127,81306586,5438492,89252153,39180960,20546916,20127343,56511382,83500096,29905795,18282103,55277252,54455664,80549379,17948378,43332022,80727721,19605133,55099248,
		18482591,44877690,93016201,49010598,41517968,24094653,22046459,23171610,20065322,46480475,57308711,83392426,20797524,55063681,82458280,18842395,81336148,44125452,16008155,43002864,79491903,
		5763020,78275321,41158734,78552773,4941482,76218643,3603242,39091951,65496056,38975369,31768112,65196094,91580102,38589847,64973456,91468551,27863269,63851864,26640671,99523325,25518020,52913738,
		24673894,83467607,19451302,56856951,18739764,45133463,81128478,70406920,17490535,43889633,16678947
	}
	pack[2]={
		39507162,57238939,56399890,81661951,16111820,42110434,82498947,6150044,53567095,56286179,44341034,16886617,77330185,30213599,5373478,77153811,4141820,90246973,88301833,25796442,82340056,18517177,
		16229315,77207191,4796100,56043446,15684835,62782218,15939448
	}
	pack[3]={
		79473793,94622638,82888408,18060565,81275309,44155002,17760003,80159717,17548456,43932460,87259077,51855378,14466224,66094973,16825874,79337169,5609226,79205581,42810973,30646525,42737833,
		31615285,30492798,67987302,30770156,28859794,63465535,22858242,2980764,51790181,42167046,79161790,53039326,3381441,82670878,80513550,42280216,3825890,39701395,88289295,50078509,44901281,5998840,
		70284332,5220687,78009994,4404099,19665973,30936186,3429238,39823987,66818682,2203790,78121572,67030233,9433350,58120309,58242947,95637655,21636650,7243511,1371589,48588176,74983881,4334811,
		42940404,78349103,31828916
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
