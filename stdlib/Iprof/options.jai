// Command-line options for the Iprof metaprogram plugin (`-plug Iprof -- -csv out.csv -min_size 50 -modules`).

handle_one_option :: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> new_cursor: int {
    s := options[cursor];
    my := cast(*My_Plugin) p;

    if s == {
      case "-csv";
        if cursor >= options.count-1 {
            log_error("Command line: Missing argument to -csv.\n");
            return cursor + 1;
        }
        my.csv_output_filename = options[cursor+1];
        return cursor + 2;

      case "-min_size";
        if cursor >= options.count-1 {
            log_error("Command line: Missing argument to -min_size.\n");
            return cursor + 1;
        }

        arg := options[cursor+1];
        result, success := string_to_int(arg);  // fails on junk after the number as well
        if !success {
            log_error("[Iprof] Command line: Argument to -min_size was expected to be an integer, but we got '%'.\n", arg);
            return cursor + 2;
        }

        my.min_size = result;
        return cursor + 2;

      case "-modules";
        my.instrument_modules = true;
        return cursor + 1;
    }

    return cursor;  // Not ours.
}

log_help :: (p: *Metaprogram_Plugin) {
    log(HELP_STRING, MINIMUM_SIZE_DEFAULT);
}

HELP_STRING :: #string DONE
-csv filename      Write the batch profile as a .csv file called 'filename'.
                   (The option is given at compile time, but the file is written when the
                   instrumented program runs, and is overwritten on every run.)

-min_size n        Only instrument procedures with at least 'n' expressions.
                   Skipping small procedures lowers overhead while keeping major locations.
                   The default is %1.

-modules           Instrument modules as well as the main program.
DONE
