module gitbackdup.main;

import std.stdio;
import gitbackdup.program_options;
import gitbackdup.args;
import gitbackdup.github;
import gitbackdup.git;

int main(string[] args){

	ProgramOptions programOptions = getProgramOptions(args);

	if(!isProgramOptionsValid(programOptions)){
		return printUsage(args[0]);
	}

	string[] githubRepoUrls = reposFor(programOptions.username);

	if(programOptions.verbose){
		writeln("Backing up github repositories for ", programOptions.username, " in ", programOptions.destination);
	}
	backupRepos(programOptions, githubRepoUrls);

	return 0;
}