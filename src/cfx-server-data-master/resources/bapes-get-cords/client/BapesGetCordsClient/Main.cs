using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using CitizenFX.Core;
using CitizenFX.Core.UI;
using static CitizenFX.Core.Native.API;

namespace BapesGetCordsClient
{
    public class Main : BaseScript
    {
        public Main()
        {
            EventHandlers["onClientResourceStart"] += new Action<string>(OnClientResourceStart);

            Tick += OnTick;
        }

        private async Task OnTick()
        {
            // Show notification when Z was pressed
            if (Game.IsControlJustReleased(0, Control.MultiplayerInfo))
            {
                Screen.ShowNotification("Hello, mister!");
            }
        }

        private void OnClientResourceStart(string commandName)
        {
            if (GetCurrentResourceName() != commandName) return;
            
            var playerCoords = Game.PlayerPed.Position;

            RegisterCommand("bapesGetCoords", new Action<int, List<object>, string>((source, args, raw) =>
            {
                TriggerEvent("chat:addMessage", new
                {
                    color = new[] {255, 0, 0},
                    args = new[] {"[Cords]", $"{playerCoords}"}
                });
                
                Debug.WriteLine(playerCoords.ToString());
            }), false);
        }
    }
}