module gitbackdup.github;
import std.uri;
import std.net.curl;
import std.json;
import std.stdio;
import std.conv;

string repositoryUrlFor(string username){
	return "https://api.github.com/users/" ~ encodeComponent(username) ~ "/repos?per_page=100";
}


string[] reposFor(string username){
	auto content = get(repositoryUrlFor(username));
	JSONValue response = parseJSON(content);

	JSONValue[] repos = response.array;
	string[] repoUrls;
	
	foreach(JSONValue repo; repos){
		repoUrls ~= repo["git_url"].str;
	}

	return repoUrls;
}