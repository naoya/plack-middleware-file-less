use inc::Module::Install;
name 'Plack-Middleware-File-Less';
all_from 'lib/Plack/Middleware/File/Less.pm';
readme_from 'lib/Plack/Middleware/File/Less.pm';

build_requires 'Test::More';
test_requires 'Test::Requires';
requires 'Plack::App::File';

auto_include_deps;
auto_set_repository;

WriteAll;
