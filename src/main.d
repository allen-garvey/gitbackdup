module gitbackdup.main;

import std.stdio;
import std.file;
import std.string;
import gitbackdup.program_options;
import gitbackdup.args;
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

	string[] repoUrls;
	
	if(programOptions.gitSource == GitSourceProvider.github){
		import gitbackdup.github;

		repoUrls = reposFor(programOptions.username);
		if(programOptions.verbose){
			writef("Backing up GitHub repositories for %s in %s\n", programOptions.username, programOptions.destination);
		}
	}
	//bitbucket
	else{
		import gitbackdup.bitbucket;

		if(programOptions.appPassword.empty){
			stderr.writef("app_password argument required for bitbucket\n");
			return 1;
		}

		if(programOptions.verbose){
			writef("Backing up Bitbucket repositories for %s in %s\n", programOptions.username, programOptions.destination);
		}

		repoUrls = reposFor(programOptions.username, programOptions.appPassword);
	}

	backupRepos(programOptions, repoUrls);

	return 0;
}