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
            Console.WriteLine("Sending chat message");
            
            TriggerEvent("chat:addMessage", new
            {
                color = new[] {255, 0, 0},
                multiline = true,
                args = new[] {"Me", "Welcome to the server!"}
            });
            
            Console.WriteLine("Sent chat message");
        }
    }
}