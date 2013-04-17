use inc::Module::Install;
name 'Plack-Middleware-File-Less';
all_from 'lib/Plack/Middleware/File/Less.pm';
readme_from 'lib/Plack/Middleware/File/Less.pm';

auto_include_deps;
auto_set_repository;
cpanfile;
WriteAll;
