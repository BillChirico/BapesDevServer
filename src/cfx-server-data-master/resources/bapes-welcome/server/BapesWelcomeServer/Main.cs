using System;
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;

namespace BapesWelcomeServer
{
    public class Class1 : BaseScript
    {
        public Class1()
        {
            Console.WriteLine("Initializing Welcome Resource");
            EventHandlers["onClientResourceStart"] += new Action<Player>(OnPlayerSpawned);
            Console.WriteLine("Initilized Welcome Resource");
        }

        private void OnPlayerSpawned(Player player)
        {
            Console.WriteLine("Sending client event");
            TriggerClientEvent(player, "playerSpawned");
        }
    }
}