using System;
using System.Threading.Tasks;
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;

namespace BapesGetCordsServer
{
    public class Main : BaseScript
    {
        public Main()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            Console.WriteLine("Hello");
        }
    }
}