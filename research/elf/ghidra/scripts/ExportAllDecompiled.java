// Ghidra headless script: export decompiled pseudo-C for every function
// whose symbol name matches `arbitrage_bot::`, `polymarket_client_sdk::`,
// or `Client::` — i.e. the application-owned code, skipping stdlib/reqwest.
//
// One file per function, named by sanitised symbol path, under
// OUTPUT_DIR (read from an environment variable so the script stays
// portable).

import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileOptions;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionIterator;
import ghidra.util.task.ConsoleTaskMonitor;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;

public class ExportAllDecompiled extends GhidraScript {

    @Override
    public void run() throws Exception {
        String outDir = System.getenv("GHIDRA_OUT");
        if (outDir == null) {
            outDir = "/tmp/ghidra_out";
        }
        new File(outDir).mkdirs();

        DecompInterface ifc = new DecompInterface();
        DecompileOptions opts = new DecompileOptions();
        ifc.setOptions(opts);
        ifc.openProgram(currentProgram);

        ConsoleTaskMonitor monitor = new ConsoleTaskMonitor();
        FunctionIterator funcs = currentProgram.getFunctionManager().getFunctions(true);

        int total = 0, written = 0;
        for (Function f : funcs) {
            total++;
            String name = f.getName(true); // namespace-qualified
            if (name == null) continue;

            // Only export application code + SDK fork
            boolean keep =
                name.contains("arbitrage_bot")
                || name.contains("polymarket_client_sdk")
                || name.startsWith("Client::")
                || name.contains("AuthenticationBuilder")
                || name.contains("TradingClient")
                || name.contains("send_debug_data");
            if (!keep) continue;

            DecompileResults res = ifc.decompileFunction(f, 120, monitor);
            if (res == null || !res.decompileCompleted()) continue;
            String c = res.getDecompiledFunction().getC();
            if (c == null || c.isEmpty()) continue;

            String safe = name.replaceAll("[^A-Za-z0-9_]+", "_");
            if (safe.length() > 200) safe = safe.substring(0, 200);
            File out = new File(outDir, safe + ".c");
            try (PrintWriter w = new PrintWriter(new FileWriter(out))) {
                w.println("// " + name);
                w.println("// entry = " + f.getEntryPoint());
                w.println();
                w.println(c);
            }
            written++;
            if (written % 25 == 0) {
                println("[progress] " + written + " functions written");
            }
        }
        println("[done] scanned=" + total + " written=" + written + " dir=" + outDir);
    }
}
