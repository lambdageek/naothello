using System.Runtime.InteropServices;

namespace libnaothello;

public static class Entrypoints
{
    [UnmanagedCallersOnly(EntryPoint="naot_Hello")]
    public static void Hello()
    {
	Console.WriteLine("Hello from NativeAOT");
    }

}
