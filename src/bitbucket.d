module gitbackdup.bitbucket;

import std.stdio;
import std.process;
import std.uri;
import std.json;

string repositoryUrlFor(string username){
	return "https://api.bitbucket.org/2.0/repositories/" ~ encodeComponent(username);
}

string httpBasicAuthFor(string username, string appPassword){
	return username ~ ":" ~ appPassword;
}


auto bitbucketApiRequestFor(string username, string appPassword, string url){
	return execute(["curl", "--silent", "--user", httpBasicAuthFor(username, appPassword), url]);
}

//returns array of ssh urls for username and app password
string[] reposFor(string username, string appPassword){
	string[] repoUrls;

	string apiUrl = repositoryUrlFor(username);

	while(true){
		auto bitbucketApiRequest = bitbucketApiRequestFor(username, appPassword, apiUrl);
		JSONValue jsonResponse = parseJSON(bitbucketApiRequest.output);

		auto rawRepos = jsonResponse.object["values"].array;
		

		foreach(rawRepo; rawRepos){
			//writeln(rawRepo["name"].str);
			
			//extract ssh url
			auto cloneUrls = rawRepo.object["links"].object["clone"].array;
			foreach(cloneUrl; cloneUrls){
				if(cloneUrl.object["name"].str == "ssh"){
					repoUrls ~= cloneUrl.object["href"].str;
					break;
				}
			}
		}

		//look to see if there are more results
		if("next" in jsonResponse.object){
			apiUrl = jsonResponse.object["next"].str;
		}
		else{
			break;
		}
	}

	return repoUrls;
}