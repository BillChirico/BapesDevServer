using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CitizenFX.Core;
using CitizenFX.Core.UI;
using static CitizenFX.Core.Native.API;

namespace BapesWelcomeClient
{
    public class Main : BaseScript
    {
        public Main()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            try
            {
                var closestPed = Util.GetClosestPed(World.GetAllPeds(), Game.PlayerPed.Position);

                Debug.WriteLine($"Player: {Game.PlayerPed.Handle} | Closest: {closestPed.Handle}");

                if (Vector3.Distance(closestPed.Position, Game.PlayerPed.Position) <= 3 &&
                    closestPed.Handle != GetPlayerPed(-1) && !IsPedInAnyVehicle(closestPed.Handle, true))
                {
                    Screen.DisplayHelpTextThisFrame("Press ~INPUT_VEH_HEADLIGHT~ to start selling ~b~");

                    if (Game.IsControlJustPressed(1, Control.VehicleHeadlight))
                    {
                        SetEntityAsMissionEntity(closestPed.Handle, true, true);
                        ClearPedTasks(closestPed.Handle);
                        FreezeEntityPosition(closestPed.Handle, true);
                        TaskStandStill(closestPed.Handle, 5000);
                        Screen.ShowNotification("CAN SELL");
                        Util.DrawText("Press ~INPUT_VEH_HEADLIGHT~ to start selling ~b~", closestPed.Position);
                    }
                }
            }

            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
            }
        }
    }

    public static class Util
    {
        public static Ped GetClosestPed(IEnumerable<Ped> peds, Vector3 point)
        {
            return peds.OrderBy(x => Vector3.Distance(x.Position, point)).ToList()
                .FirstOrDefault(x => x != Game.PlayerPed);
        }

        public static Vector3 GetClosest(IEnumerable<Vector3> points, Vector3 point)
        {
            return points.OrderBy(x => Vector3.Distance(x, point)).ToList().FirstOrDefault();
        }

        public static Entity GetClosest(IEnumerable<Entity> entities, Vector3 point)
        {
            return entities.OrderBy(x => Vector3.Distance(x.Position, point)).ToList().FirstOrDefault();
        }

        public static void DrawText(string text, Vector3 position)
        {
            SetTextScale(0, 0.35f);
            SetTextFont(0);
            SetTextProportional(true);
            SetTextColour(255, 255, 255, 255);
            SetTextDropshadow(0, 0, 0, 0, 0);
            SetTextEdge(2, 0, 0, 0, 150);
            SetTextDropShadow();
            SetTextOutline();
            SetTextEntry(text);
            SetTextCentre(true);
            DrawText(text, position);
        }
    }
}