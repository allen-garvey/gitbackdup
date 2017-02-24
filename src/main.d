module gitbackdup.main;

import std.stdio;
import gitbackdup.args;

int main(string[] args){

	ProgramOptions programOptions = getProgramOptions(args);

	if(!isProgramOptionsValid(programOptions)){
		return printUsage(args[0]);
	}

	return 0;
}