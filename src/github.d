module gitbackdup.github;
import std.uri;
import std.string;
import std.net.curl;
import std.process;
import std.json;
import std.stdio;
import std.conv;
import std.regex;
import std.algorithm.searching;

string repositoryUrlFor(string username, int pageNum=1){
	return "https://api.github.com/users/" ~ encodeComponent(username) ~ "/repos?per_page=100&page=" ~ to!string(pageNum);
}

int pagesFor(string responseHeader){
	string linkField = null;
	//look for link field in response
	foreach(string line; splitLines(responseHeader)){
		if(startsWith(line, "Link:")){
			linkField = line;
			break;
		}
	}
	//no link field means there is only one page
	if(linkField == null){
		return 1;
	}
	//find page number of last page
	auto m = matchAll(linkField, regex(`page=\d+`));
	string result;
	while(!m.empty){
		result = m.front.hit;
		m.popFront();
	}

	result = replaceAll(result, regex(`[^\d]`), "");

	return to!int(result);
}

int repositoryPagesFor(string username){
	auto headRequest = execute(["curl", "--silent", "-I", repositoryUrlFor(username)]);
	return pagesFor(headRequest.output);

}


string[] reposFor(string username){
	string[] repoUrls;
	int pages = repositoryPagesFor(username);

	for(int pageNum=1;pageNum<=pages;pageNum++){
		auto content = get(repositoryUrlFor(username, pageNum));
		JSONValue response = parseJSON(content);
		JSONValue[] repos = response.array;
		foreach(JSONValue repo; repos){
			repoUrls ~= repo["git_url"].str;
		}
	}

	return repoUrls;
}