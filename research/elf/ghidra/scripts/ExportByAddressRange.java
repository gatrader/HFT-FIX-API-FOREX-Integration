// Export every function (named OR anonymous FUN_*) inside the address
// ranges that hold arbitrage_bot strategy logic. The top-level async
// state machines (run_single_market, run_trading_loop,
// run_spread_capture_loop) are jumptables Ghidra can't follow, but the
// individual state-handler bodies are compiled as separate functions
// that live in the same range and do decompile cleanly.

import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileOptions;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionIterator;
import ghidra.util.task.ConsoleTaskMonitor;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;

public class ExportByAddressRange extends GhidraScript {

    // Range covering the three closure clusters we already saw:
    //   run_single_market: 0x189670, 0x1e6150, 0x20c040
    //   market_ws::run_trading_loop: 0x19ef40, 0x1f7330, 0x21d220
    //   spread_capture_ws: 0x197950, 0x1f08f0, 0x2167e0, 0x1e3b00
    //   user_ws: ~0x20xxxx
    // Pad generously on both ends.
    private static final long RANGE_START = 0x180000L;
    private static final long RANGE_END   = 0x230000L;

    @Override
    public void run() throws Exception {
        String outDir = System.getenv("GHIDRA_OUT");
        if (outDir == null) outDir = "/tmp/ghidra_out_range";
        new File(outDir).mkdirs();

        DecompInterface ifc = new DecompInterface();
        ifc.setOptions(new DecompileOptions());
        ifc.openProgram(currentProgram);

        ConsoleTaskMonitor monitor = new ConsoleTaskMonitor();
        FunctionIterator funcs = currentProgram.getFunctionManager().getFunctions(true);

        int total = 0, written = 0;
        for (Function f : funcs) {
            Address ep = f.getEntryPoint();
            long off = ep.getOffset();
            if (off < RANGE_START || off >= RANGE_END) continue;
            total++;

            DecompileResults res = ifc.decompileFunction(f, 180, monitor);
            if (res == null || !res.decompileCompleted()) continue;
            String c = res.getDecompiledFunction().getC();
            if (c == null || c.isEmpty()) continue;

            String name = f.getName(true);
            if (name == null) name = "FUN_" + ep;
            String safe = name.replaceAll("[^A-Za-z0-9_]+", "_");
            if (safe.length() > 160) safe = safe.substring(0, 160);
            File out = new File(outDir, String.format("%08x__%s.c", off, safe));
            try (PrintWriter w = new PrintWriter(new FileWriter(out))) {
                w.println("// " + name);
                w.println("// entry = " + ep);
                w.println();
                w.println(c);
            }
            written++;
            if (written % 50 == 0) {
                println("[progress] " + written + " / " + total);
            }
        }
        println("[done] in-range=" + total + " written=" + written);
    }
}
