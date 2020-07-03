using System;
using CitizenFX.Core;

namespace BapesWelcomeClient
{
    public class Class1 : BaseScript
    {
        public Class1()
        {
            EventHandlers["playerSpawned"] += new Action<Player>(OnPlayerSpawn);
        }

        private static void OnPlayerSpawn(Player obj)
        {
            TriggerEvent("chatMessage", "SYSTEM", new[] {255, 0, 0}, "Welcome to the server!");
        }
    }
}