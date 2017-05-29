--极光之启翼魔神✿神绮
function c15070.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Nef.AddXyzProcedureCustom(c,c15070.mfilter,c15070.xyzcheck,2,3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(15070,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c15070.cost)
	e2:SetTarget(c15070.target)
	e2:SetOperation(c15070.operation)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCondition(c15070.rmcon)
	e4:SetTarget(c15070.rmtg)
	e4:SetOperation(c15070.rmop)
	c:RegisterEffect(e4)
end
function c15070.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,12) or (c:IsSetCard(0x150) and c:GetOriginalLevel()>=4)
end
function c15070.xyzcheck(g,xyzc)
	return not g:IsExists(c15070.counter[g:GetCount()],1,nil,xyzc)
end
c15070.counter={
	[2]=function(c,xyzc) return not c:IsXyzLevel(xyzc,12) end,
	[3]=function(c,xyzc) return not c:IsSetCard(0x150) or c:GetOriginalLevel()<4 end,
}
function c15070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c15070.filter(c)
	return c:IsSetCard(0x150) and c:IsAbleToHand()
end
function c15070.tuhanfilter(c,lv)
	return c:GetLevel()<=lv and not c:IsType(TYPE_XYZ) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c15070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15070.filter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_DECK)
end
function c15070.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c15070.filter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local lv=g:GetFirst():GetLevel()
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local sg=fg:Filter(c15070.tuhanfilter,nil,lv)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function c15070.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:IsSetCard(0x150) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c15070.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c15070.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
