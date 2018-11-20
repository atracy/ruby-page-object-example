# Ludus
Ruby Automated Regression/Integration Tests for Apps.

## How to install:
#### Prerequesites:  
1. Make sure XCode is installed, up to date, and the license has been agreed to
1. Install XCode command line tools:  
`$ xcode-select --install`
1. Install [Homebrew](https://brew.sh/):  
`$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
1. Install git:  
`$ brew install git`

#### Install:
1. Clone the Ludus GitHub project and change directories into it:
```bash
$ git clone https://github.com/octanner/ludus.git
$ cd ludus
```
1. Run the setup shell script. This will install any required programs from Homebrew, install and update any required gems, and create required local environment files.  
`$ sh ./bin/setup.sh`
1. Verify your version of Ruby matches the one set in `.ruby-version` by running:
`$ rbenv version`
1. Update your shell profile file (i.e. `~/.bash_profile` or `~/.zshrc`) with the following:
```bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```
1. Install an IDE (e.g. Atom, Rubymine, or Sublime).

### Install with docker:
If you don't want to corrupt your local development box or going through the pain of installing all of the tools required to run tests, you can use docker to run your tests in your development box. It will help you getup running setup fast.

Go to ludus directory and follow the below steps to setup the docker to run tests inside docker:

##### Step1:
```bash
$ docker build -f Dockerfile.local -t ludus_local_dev .
```
##### Step2:
Run `$ docker images` to see the images build from the above command.

##### Step3:
Run `$ docker run -it -v /$(pwd):/ludus ludus_local_dev bash` - it will get you inside the docker with source code mounted and run the tests as you would or refer `Running Tests` section.

## Environments:
The four environments are QA, dev, stage, & prod. Before running the test suite you will need to set any required local environment variables. First, make sure the setup shell script above created a `.local` file for each environment plus one for global. You should have:
```
config/environments/dev
config/environments/dev.local
config/environments/global
config/environments/global.local
config/environments/prod
config/environments/prod.local
config/environments/qa
config/environments/qa.local
config/environments/stage
config/environments/stage.local
```
If these were not created, either create the files manually (they can be empty) or run the following script to have them created automatically:  
`ruby bin/create_local_environment_variable_files_script.rb`  
In `global.local` you will need the following environment variables.
```
SAUCE_USERNAME=
SAUCE_ACCESS_KEY=
APPLITOOLS_ACCESS_KEY=
MAILINATOR_TOKEN=
```
By default all tests are run in QA. To run any tests in a different environment, prod for example, prepend `APP_ENV=prod ` to the command.

## Running Tests:
* Run in sequence:  
`$ rspec spec/features/[test_dir/[test_name]]`
* Run in parallel:  
`$ parallel_rspec spec/features/[test_dir/[test_name]]`

## RSpec Tags
[RSpec tags](https://relishapp.com/rspec/rspec-core/v/2-4/docs/filtering/exclusion-filters) can be added to features or scenarios in order to accommodate filtering when running tests. The following tags are currently configured:
* `:broken` - test will be skipped (equivalent to `broken: true`)
* `qa: false` - test will be skipped on the qa environment (`qa: true` has no effect)
* `prod: false` - test will be skipped on the prod environment (`prod: true` has no effect)
* `dev: false` - test will be skipped on the dev environment (`dev: true` has no effect)
* `stage: false` - test will be skipped on the stage environment (`stage: true` has no effect)
* `sauce: true` - test will be run on Sauce Labs instead of locally. This is usually set as `sauce: app.sauce`.
* `sauce: false` - test will be skipped on Sauce Labs when the `USESAUCE` environment variable is passed in as true

**Please always leave a comment explaining why a test is marked as broken, skipped on any environment, or skipped on Sauce Labs**

## Branching Strategy / Promotion Pipeline

##### What:
Our branching strategy is a code promotion pipeline wherein code flows from new feature branches to the `stage` branch and then from `stage` to `master`.

new_feature_1 \  
new_feature_2 >>> stage >>> master  
new_feature_3 /

##### Why:
1. To streamline the process of getting new code into the codebase by only requiring a quick set of smoke tests to pass in order to promote new features to `stage`.
2. To ensure high quality, well maintained tests by requiring the full test suite to pass before code can be promoted from `stage` to `master`.

##### How:
The primary rule is that`master` must never be ahead of `stage`, which is to say `master` must never have code that is not already on `stage`. The when developing a new feature the git workflow is to simply treat `stage` as the main branch in the same way most repos use `master`. So new feature branches should be branched off from `stage`. Generally speaking, you shouldn't need a copy of master on your local development machine.

Promotions from `stage` to `master` should be relatively frequent so the two branches don't get too far apart from one another, say one PR for every few new features have been promoted to `stage`.

##### Hotfixes:
In a time sensitive situation where new code needs to be introduced to `master` and can't wait for the promotion pipeline, follow this "hotfix" process. This should be relatively rare.
1. Create a new feature branch off `master` and implement the necessary changes.
1. Submit a PR to `master` and merge it in. Do not delete the new feature branch.
1. Submit a PR to `stage`, update the new feature branch from `stage`, merge it in, and then delete the new feature branch.


## Update Guidelines:

Please follow these guidelines when updating gems, updating the Ruby version, or making significant changes to `spec helper` or other configurations that affect all tests.
1. The update must be done on its own branch, such that a rollback would be easy if it were necessary
1. That branch must not contain any code changes that are not required for the update
1. After the pull request is submitted all tests must be run in all environments and platforms/browsers to make sure the changes didn't break anything
1. All engineers who are responsible for tests within the project need to approve the pull request after they have verified their tests pass before the update can be merged to master

## Standards:
1. First and foremost we follow the same standards as everyone else here at O.C. Tanner. Currently this is the [Github Ruby Style Guides] (https://github.com/octanner/ruby)
1. Use the Rubocop Gem to verify these standards are met:
  1. from the command line run:  
  `$ rubocop`
  1. rubocop can be ran at a project or file level:  
  `$ rubocop [/filepath/[filename.rb]]`

Repo
1. One Repo
1. Broken up by Project
1. Own spec files

Tools:
1. We use Ruby as much as we can.
1. Our test harness is 'rspec'
1. For tests we use Capybara

Drivers
1. Webkit
1. Selenium

Structure
1. Object oriented programming.
1. Model our Pages/Features in Classes.
1. Reusable Methods to handle repeated scenarios.



Helpful Info, Additional Resources

[Sauce Labs Dashboard](https://saucelabs.com/beta/dashboard/)

There may be additional latency when using a remote webdriver to run tests on Sauce Labs. Timeouts or Waits may need to be increased.
[Selenium tips regarding explicit waits](https://wiki.saucelabs.com/display/DOCS/Best+Practice%3A+Use+Explicit+Waits)

[Sauce Labs Documentation](https://wiki.saucelabs.com/)
[SeleniumHQ Documentation](http://www.seleniumhq.org/docs/)
[RSpec Documentation](http://rspec.info/documentation/)
[Capybara Documentation](https://github.com/jnicklas/capybara)
[Ruby Documentation](http://ruby-doc.org/)

A great resource to search for issues not explicitly covered by documentation.
[Stack Overflow](http://stackoverflow.com/)
