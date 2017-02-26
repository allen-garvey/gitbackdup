module gitbackdup.args;

import std.getopt;
import std.stdio;
import std.string;
import std.path;

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
	    "verbose|v", 					&programOptions.verbose//,   // flag
	    //"source|s", "github|bitbucket", &programOptions.gitSource //just github supported for now
    );
    programOptions.gitSource = GitSourceProvider.github;

    if(!programOptions.destination.empty){
    	programOptions.destination = absolutePath(programOptions.destination);
    }

    return programOptions;
}

int printUsage(string programName){
	writeln("usage: " ~ programName ~ " --username=github_username --destination=directory");
	return 1;
}

bool isProgramOptionsValid(ProgramOptions programOptions){
	if(programOptions.username.empty || programOptions.destination.empty){
		return false;
	}
	return true;
}