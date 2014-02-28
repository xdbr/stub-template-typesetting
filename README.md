stub
====

stunningly simple & stupid language agnostic project generator

## Usage

### Stubbing out a project

#### Using local template

    ./stub project:new template=cpp to=var/foo name=foobar version=1.2.3

#### Using remote (git-repo) template

    ./stub project:new template=http://path/to/repo.git to=var/bar name=foobar version=1.2.3

#### Finding out about variables that need to be set / optionally can be set

    ./stub project:info template=template-name

### Defining a project stub

1. Generate your skeleton of how you want your files and folders to be layed out
2. substitute all variables with mustaches that you liked to be filled in, e.g. `class {{classname}}`. This will be set by using `stub project new template=yourtemplatename classname=foo`
3. write a file `project.json`, put it in the top directory of you skeleton.
4. Use the following layout for your `project.json`:

    {
      "requires": {
        "name"   : "string",
        "version": "versionstring"
      },
      "optional": {
        "author": "Quux"
      }
    }

## Author

Daniel B <daniel@codeedition.de>

## License

WTFPL