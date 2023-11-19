example.ini: example_pre.ini example.vars
	cat example.vars example_pre.ini | sed -n -f preproc.sed > example.ini
README: README_unprocessed
	sed -n -f preproc.sed < README_unprocessed > README
clean:
	rm README
	rm example.ini
