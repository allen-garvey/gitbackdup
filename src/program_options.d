module gitbackdup.program_options;


enum GitSourceProvider { github, bitbucket };

struct ProgramOptions {
	string destination;
	string username;
	bool verbose;
	GitSourceProvider gitSource;
};