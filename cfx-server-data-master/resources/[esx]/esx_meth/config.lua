MF_DopeMeth = {}
local MFD = MF_DopeMeth
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

Citizen.CreateThread(function(...)
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
    Citizen.Wait(0)
  end
end)

MFD.FoodDrainSpeed      = 0.0300
MFD.WaterDrainSpeed     = 0.0300
MFD.QualityDrainSpeed   = 0.0080

MFD.GrowthGainSpeed     = 1.5000
MFD.QualityGainSpeed    = 0.0200

MFD.SyncDist = 50.0
MFD.InteractDist = 2.5
MFD.PoliceJobLabel = "police"
MFD.WeedPerBag = 5
MFD.JointsPerBag = 10
MFD.BagsPerPapers = 1

MFD.PlantTemplate = {
   ["Gender"] = "Preparation of Methamphetamine",
  ["Quality"] = 0.0,
   ["Growth"] = 0.0,
    ["Water"] = 20.0,
     ["Food"] = 20.0,
    ["Stage"] = 1,
}

MFD.ItemTemplate = {
     ["Type"] = "Water",
  ["Quality"] = 0.0,
}

MFD.Objects = {
  [1] = "v_ret_ml_tablea",
  [2] = "v_ret_ml_tablea",
  [3] = "v_ret_ml_tablea",
  [4] = "v_ret_ml_tablea",
  [5] = "v_ret_ml_tablea",
  [6] = "v_ret_ml_tablea",
  [7] = "v_ret_ml_tablea", 
}