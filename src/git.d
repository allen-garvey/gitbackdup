module gitbackdup.git;

import std.process;
import std.file;
import std.path;
import gitbackdup.args;


void backupRepos(ProgramOptions programOptions, string[] repoUrls){
	foreach(string repoUrl; repoUrls){
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

