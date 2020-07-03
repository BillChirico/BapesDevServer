using System;
using CitizenFX.Core;

namespace BapesWelcomeServer
{
    public class Class1 : BaseScript
    {
        public Class1()
        {
            EventHandlers["onClientResourceStart"] += new Action<Player>(OnPlayerSpawned);
        }

        private void OnPlayerSpawned(Player player)
        {
            TriggerClientEvent(player, "playerSpawned");
        }
    }
}