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
            await Delay(0);

            try
            {
                var closestPed = Util.GetClosest(World.GetAllPeds(), Game.PlayerPed.Position);

                Debug.WriteLine($"Player: {Game.PlayerPed.Handle} | Closest: {closestPed.Handle}");

                if (Vector3.Distance(closestPed.Position, Game.PlayerPed.Position) <= 10 &&
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
                    }
                }
            }

            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
            }

            // Show notification when Z was pressed
            // if (Game.IsControlPressed(0, Control.MultiplayerInfo))
            // {
            //     Text text = new Text("Sell drugs", new PointF(Game.PlayerPed.Position.X, Game.PlayerPed.Position.Y),
            //         10.0f, Color.FromArgb(255, 255, 255), Font.Monospace, Alignment.Center, true, true);
            //     text.Draw();
            //     Screen.ShowNotification("Can sell");
            // }
        }
    }

    public static class Util
    {
        public static Ped? GetClosestPed(float x, float y, float z)
        {
            var searchPosition = new Vector3(x, y, z);
            var allPeds = World.GetAllPeds();
            Ped? closestPed = null;

            foreach (var ped in allPeds)
                if (closestPed != null)
                {
                    if (Vector3.Distance(searchPosition, ped.Position) <
                        Vector3.Distance(searchPosition, closestPed.Position)) closestPed = ped;
                }
                else
                {
                    closestPed = ped;
                }

            return closestPed;
        }

        public static Vector3 GetClosest(IEnumerable<Vector3> points, Vector3 point)
        {
            return points.OrderBy(x => Vector3.Distance(x, point)).ToList().FirstOrDefault();
        }

        public static Entity GetClosest(IEnumerable<Entity> entities, Vector3 point)
        {
            return entities.OrderBy(x => Vector3.Distance(x.Position, point)).ToList().FirstOrDefault();
        }
    }
}