call registers#add("!", "system('date --iso')[:-2]")
call registers#add("@", "registers#get_func_name()")
call registers#add("$", "line('$')")
