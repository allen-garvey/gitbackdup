module gitbackdup.args;

import std.getopt;
import std.stdio;
import std.string;

enum GitSourceProvider { github, bitbucket };

struct ProgramOptions {
	string destination;
	string username;
	bool verbose;
	GitSourceProvider gitSource;
};


ProgramOptions getProgramOptions(string[] args){
	ProgramOptions programOptions;

	GetoptResult options = getopt(
	    args,
	    "username|u",  					&programOptions.username,
	    "destination|d",    			&programOptions.destination,
	    "verbose|v", 					&programOptions.verbose,   // flag
	    "source|s", "github|bitbucket", &programOptions.gitSource
    );

    return programOptions;
}

int printUsage(string programName){
	writeln("usage: " ~ programName ~ " --username=github_username");
	return 1;
}

bool isProgramOptionsValid(ProgramOptions programOptions){
	if(programOptions.username.empty){
		return false;
	}
	return true;
}