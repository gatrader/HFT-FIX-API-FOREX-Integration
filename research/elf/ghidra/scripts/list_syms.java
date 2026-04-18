import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionIterator;

public class list_syms extends GhidraScript {
    @Override
    public void run() throws Exception {
        FunctionIterator funcs = currentProgram.getFunctionManager().getFunctions(true);
        for (Function f : funcs) {
            String n = f.getName(true);
            if (n != null && (n.contains("handle_") || n.contains("process_") || n.contains("on_fill") || n.contains("evaluate") || n.contains("dutch"))) {
                if (n.contains("arbitrage_bot") || n.contains("polymarket")) {
                    println(f.getEntryPoint() + "  " + n);
                }
            }
        }
    }
}
