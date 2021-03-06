module gitbackdup.args;

import std.getopt;
import std.stdio;
import std.string;
import std.path;
import std.file;
import gitbackdup.program_options;

ProgramOptions getProgramOptions(string[] args){
	ProgramOptions programOptions;

	try{
		GetoptResult options = getopt(
		    args,
		    "username|u",  					&programOptions.username,
		    "destination|d",    			&programOptions.destination,
		    "verbose|v", 					&programOptions.verbose,   // flag
		    "app_password",					&programOptions.appPassword, //for bitbucket
		    "source|s", "github|bitbucket", &programOptions.gitSource //just github supported for now
	    );
	}
	catch(Exception e){
		return programOptions;
	}

    if(!programOptions.destination.empty){
    	programOptions.destination = absolutePath(expandTilde(programOptions.destination));
    }

    return programOptions;
}

int printUsage(string programName){
	stderr.writef("usage: %s --username=github_username --source=github|bitbucket --destination=directory\n", programName);
	return 1;
}

bool isProgramOptionsValid(ProgramOptions programOptions){
	if(programOptions.username.empty || programOptions.destination.empty){
		return false;
	}
	return true;
}

bool isDestinationValid(ProgramOptions programOptions){
	if(exists(programOptions.destination) && !isDir(programOptions.destination)){
		return false;
	}
	return true;
}


