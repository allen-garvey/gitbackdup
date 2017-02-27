module gitbackdup.main;

import std.stdio;
import std.file;
import gitbackdup.program_options;
import gitbackdup.args;
import gitbackdup.github;
import gitbackdup.git;

int main(string[] args){

	ProgramOptions programOptions = getProgramOptions(args);

	if(!isProgramOptionsValid(programOptions)){
		return printUsage(args[0]);
	}
	if(!isDestinationValid(programOptions)){
		stderr.writef("%s is not a directory\n", programOptions.destination);
		return 1;
	}
	if(!exists(programOptions.destination)){
		if(programOptions.verbose){
			writef("Creating directory %s\n", programOptions.destination);
		}
		mkdirRecurse(programOptions.destination);
	}

	string[] githubRepoUrls = reposFor(programOptions.username);

	if(programOptions.verbose){
		writeln("Backing up github repositories for ", programOptions.username, " in ", programOptions.destination);
	}
	backupRepos(programOptions, githubRepoUrls);

	return 0;
}