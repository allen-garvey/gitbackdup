module gitbackdup.git;

import std.stdio;
import std.process;
import std.file;
import std.path;
import std.parallelism;
import gitbackdup.program_options;


void backupRepos(ProgramOptions programOptions, string[] repoUrls){
	foreach(string repoUrl; taskPool.parallel(repoUrls)){
		if(programOptions.verbose){
			writeln("Backing up ", dirNameForRepo(repoUrl));
		}
		if(isRepoAlreadyCloned(programOptions, repoUrl)){
			gitPullUrl(programOptions, repoUrl);
		}
		else{
			gitCloneUrl(programOptions, repoUrl);
		}
	}
}

//will fail on windows, because windows uses \ as separator
string dirNameForRepo(string repoUrl){
	return baseName(repoUrl, ".git");
}
unittest{
    assert(dirNameForRepo("https://github.com/allen-garvey/test.git") == "test");
}

string absolutePathForRepo(ProgramOptions programOptions, string repoUrl){
	return absolutePath(dirNameForRepo(repoUrl), programOptions.destination);
}

bool isRepoAlreadyCloned(ProgramOptions programOptions, string repoUrl){
	return exists(absolutePathForRepo(programOptions, repoUrl));
}

int gitCloneUrl(ProgramOptions programOptions, string repoUrl){
	auto gitClone = execute(["git", "clone", repoUrl], null, Config.none, size_t.max, programOptions.destination);
	return gitClone.status;
}

int gitPullUrl(ProgramOptions programOptions, string repoUrl){
	string repoDirectory = absolutePathForRepo(programOptions, repoUrl);

	auto gitPull = execute(["git", "pull"], null, Config.none, size_t.max, repoDirectory);
	return gitPull.status;
}

