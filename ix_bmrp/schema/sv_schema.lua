function Schema:SlapPlayer(client)
	if (IsValid(client) and client:IsPlayer()) then
		client:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(0, 20)))
		client:TakeDamage(math.random(5, 10))
	end
end

function Schema:Think()
  local PortalList = {
    [1] = {Vector(4144.660645, 2276.287354, -1638.249634),Vector(-13325.453125, -7228.963867, -6806.296387)},
    [2] = {Vector(-5980.573730, -12048.495117, -3607.926270),Vector(5003.149902, 2370.077393, -1572.024048)},
    [3] = {Vector(-9680.643555, -11170.972656, -6559.689453),Vector(-7327.559082, -10680.342773, -8451.554688)},
    [4] = {Vector(-8005.711426, -6891.876953, -7713.630371),Vector(-9964.928711, -5926.929688, -5322.401855)},
    [5] = {Vector(-11516.889648, -9002.839844, -6401.003418),Vector(-12733.323242, -6659.335449, -6674.834473)},
    [6] = {Vector(-3058.836914, -4525.721191, -7614.666992),Vector(-14020.002930, -8620.474609, -3508.848877)},
    [7] = {Vector(-13968.669922, -9160.685547, -5676.554688),Vector(-9247.453125, -3422.671875, -6054.428223)},
    [8] = {Vector(-3094.434570, -4692.599609, -6129.205078),Vector(-4800.740723, -12080.416016, -7911.141113)},
  }
  -- Portal Loop
  for A,B in pairs(PortalList) do
    local EntList = ents.FindInSphere(B[1],100)
    for k,v in pairs(EntList) do
      if v:IsPlayer() then 
        v:EmitSound("beams/beamstart5.wav", 75, 100, 0.5)
        v:SetPos(B[2])
      end
    end
  end
  local RandPortals = {
    Vector(-12577.118164, -7673.434570, -6641.915527),
    Vector(681.726196, 12836.467773, 1379.861084),
    Vector(7081.166504, 6177.304688, 129.750275),
    Vector(2187.307617, 1971.616333, 266.735931),
    Vector(2193.233398, 863.154968, -2019.225830),
    Vector(-1911.285767, -2288.684570, -725.919922),
    Vector(-2301.395752, -941.634583, 308.620300),
    Vector(462.413391, -4806.683594, 236.136719),
    Vector(4890.322266, -3984.982910, 280.494080),
    Vector(-2912.737549, -8849.064453, -9.008625),
    Vector(-3092.326416, -7775.978516, 258.878845),
    Vector(-7133.402344, -1804.881226, 472.157623),
    Vector(-6952.338379, 540.759521, 576.044189),
    Vector(-9412.200195, 1785.706543, 554.503479),
    Vector(2203.857666, -861.502869, 463.182770),
    Vector(-997.077637, 372.712006, -599.707214),
    Vector(-2489.105713, 436.428711, -999.505920),
  }
  local EntList = ents.FindInSphere(Vector(-9419.756836, -11114.592773, -8367.743164),100)
  for k,v in pairs(EntList) do
    if v:IsPlayer() then 
      v:EmitSound("beams/beamstart5.wav", 75, 100, 0.5)
      v:SetPos(table.Random(RandPortals))
    end
  end
end