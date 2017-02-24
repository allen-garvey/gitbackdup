module gitbackdup.main;

import std.stdio;
import gitbackdup.args;
import gitbackdup.github;

int main(string[] args){

	ProgramOptions programOptions = getProgramOptions(args);

	if(!isProgramOptionsValid(programOptions)){
		return printUsage(args[0]);
	}

	reposFor(programOptions.username);

	return 0;
}