#Welcome to the README for the Apache Royale CLI tool

##To Install:
npm install @apache-royale/cli

## How to use

####Setup
```cmd
royale new  my-royale-app 
cd my-royale-app
```
This creates a simple app: my-royale-app/src/Main.mxml

#### Run in debug mode

```cmd
royale serve:debug
```
* Compiles the project in debug mode
* Compiles with source map option
* Starts a http server and serves the files from the bin/js-debug directory 
* Opens the default browser and navigates to http://localhost:3000
* Listens to src folder
* When any file changes, it will recompile the app

#### Run in release mode

```cmd
royale serve:release
```
* Compiles the project in release mode
* Starts a http server and serves the files from the bin/js-release directory
* Opens the default browser and navigates to http://localhost:3001


