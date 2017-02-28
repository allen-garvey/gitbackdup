module gitbackdup.program_options;


enum GitSourceProvider { github, bitbucket };

struct ProgramOptions {
	string destination;
	string username;
	bool verbose;
	GitSourceProvider gitSource;
	string appPassword; //used for bitbucket authentication
};