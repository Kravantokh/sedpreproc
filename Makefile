example.ini: example_pre.ini example.vars
	cat example.vars example_pre.ini | sed -n -f preproc.sed > example.ini
README.md: README_unprocessed
	sed -n -f preproc.sed < README_unprocessed > README.md
clean:
	rm README.md
	rm example.ini
