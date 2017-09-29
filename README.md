# Apache Royale

The Apache Royale project is working on a next-generation Flex SDK, called FlexJS. FlexJS has the goal of allowing applications developed in MXML and ActionScript to not only run in the Flash/AIR runtimes, but also to run natively in the browser without Flash, on mobile devices as a PhoneGap/Cordova application, and in embedded JS environments such as Chromium Embedded Framework. FlexJS has the potential to allow your MXML and ActionScript code to run in even more places than Flash currently does.

For detailed information about FlexJS, please visit:

<https://cwiki.apache.org/confluence/display/FLEX/FlexJS>

For detailed information about Apache Royale, please visit:

<http://royale.apache.org>

# Getting FlexJS

Getting the source code from GitHub is the recommended way to get FlexJS. You can checkout the source via git using the following commands:

```bash
git clone https://github.com/apache/royale-asjs.git royale-asjs
cd royale-asjs
git checkout develop
```

You may also use a precompiled binary convenience package to develop FlexJS applications using your favorite IDE. In addition to that, FlexJS is available as Maven artifacts and through Node Package Manager (NPM).

# Building FlexJS

## Prerequisites

Before building FlexJS you must install the following software and set the corresponding environment variables using absolute file paths. Relative file paths will result in build errors. The set of prerequisites is different depending on whether you want to compile your projects to SWF or not.

### Java

FlexJS requires Java SDK 1.6 or greater to be installed on your computer. For more information on installing the Java SDK, see:

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>

- **Environment variable**

  Set the JAVA_HOME environment variable to the Java SDK installation path.

- **PATH**

  Add the bin directory of JAVA_HOME to the PATH.

  On Windows, set PATH to
  ```batch
  PATH=%PATH%;%JAVA_HOME%\bin
  ```

  On a Mac, set PATH to
  ```bash
  export PATH="$PATH:$JAVA_HOME/bin"
  ```

### Ant

FlexJS requires Ant 1.7.1 or greater to be installed on your computer. For more information on installing Ant, see:

<http://ant.apache.org/>

- **Environment variable**

  Set the ANT_HOME environment variable to the Ant installation path.

- **PATH**

  Add the bin directory of ANT_HOME to the PATH.

  On Windows, set PATH to
  ```batch
  PATH=%PATH%;%ANT_HOME%\bin
  ```

  On a Mac, set PATH to
  ```bash
  export PATH="$PATH:$ANT_HOME/bin"
  ```









============================================================================
SOFTWARE                                    ENVIRONMENT VARIABLE    REQUIRED
============================================================================

Java SDK 1.6 or greater (*1)                JAVA_HOME               Yes
    (for Java 1.7 see note at (*2))

Ant 1.7.1 or greater (*1)                   ANT_HOME                Yes
    (for Java 1.7 see note at (*2))

Adobe Flash Player playerglobal swcs (*3)   PLAYERGLOBAL_HOME       Yes

Adobe Flash Player Content Debugger (*5)    FLASHPLAYER_DEBUGGER    Yes

Adobe AIR Integration Kit (*4)              AIR_HOME                SWF

============================================================================

1. The bin directories for ANT_HOME and JAVA_HOME should be added to your PATH.

   On Windows, set PATH to

   ```batch
   PATH=%PATH%;%ANT_HOME%\bin;%JAVA_HOME%\bin
   ```

   On the Mac (bash), set PATH to

   ```bash
   export PATH="$PATH:$ANT_HOME/bin:$JAVA_HOME/bin"
   ```

   On Linux make sure you path include ANT_HOME and JAVA_HOME.

2. If you are using Java SDK 1.7 or greater on a Mac you must use Ant 1.8 or greater. If you use Java 1.7 with Ant 1.7, ant reports the java version as 1.6 so the JVM args for the data model (-d32/-d64) will not be set correctly and you will get compile errors.

3. The Adobe Flash Player playerglobal.swc for 11.1 can be downloaded from:

   <http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc>

   Use the URL above to download playerglobal11_1.swc. Create a directory, create a folder path in that directory for player/11.1 and copy playerglobal11_1.swc to player/11.1/playerglobal.swc.

   Set PLAYERGLOBAL_HOME to the absolute path of the player directory (not including the version subdirectory). The target-player option controls which PLAYERGLOBAL_HOME subdirectory is used.

   Other more recent versions of Adobe Flash Player playerglobal.swc can be downloaded from:

   http://<i></i>download.macromedia.com/get/flashplayer/updaters/[version.major]/playerglobal[version.major]_[version.minor].swc

   (e.g. <http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc>)

   These can be used with Apache FlexJS but not all have not been fully tested.

   Copy the target playerglobal.swc to the directory:

   frameworks/libs/player/[version.major].[version.minor]/playerglobal.swc

4. The Adobe AIR integration kit for Windows can be downloaded from:

   <http://airdownload.adobe.com/air/win/download/16.0/AdobeAIRSDK.zip>

   The Adobe AIR integration kit for Mac can be downloaded from:

   <http://airdownload.adobe.com/air/mac/download/16.0/AdobeAIRSDK.tbz2>

   The Adobe AIR integration kit for Linux can be downloaded from:

   <http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRSDK.tbz2>

   Download the AIR SDK for your platform and unzip it. Set AIR_HOME to the absolute path of the AIR SDK directory.

   This version of Apache FlexJS was certified for use with Adobe AIR 16 and is compatible with version 3.1 and up.

5. The Adobe Flash Player content debuggers can be found here:

   <http://www.adobe.com/support/flashplayer/downloads.html>

   This version of Apache FlexJS was certified for use with Adobe Flash Player 11.1, and is compatible with version 10.2 and up. It has been tested with versions 16.0 on Windows and Mac. It has been compiled, but not fully tested, with other Adobe Flash Player versions. It has not been fully tested on Linux.

   On Windows, set FLASHPLAYER_DEBUGGER to the absolute path including the filename of the FlashPlayerDebugger.exe. Note the filename of flash player debugger may be different, e.g. C:\MyPath\FlashPlayerDebugger.exe.

   On the Mac, set FLASHPLAYER_DEBUGGER to the absolute path of 'Flash Player Debugger.app/Contents/MacOS/Flash Player Debugger'

   On Linux, set FLASHPLAYER_DEBUGGER to the absolute path of flashplayerdebugger.

FlexJS requires code from several other Apache Royale git repositories. To get the latest sources via git, first follow the instructions in ‘Prerequisites’, then from the royale-asjs directory, run:

```bash
ant all
```

This will clone all of the upstream repositories, checkout the develop branches then run the builds in those repositories in the correct order.

FlexJS is a large project. It requires some build tools which must be installed prior to building the SDK. Some of these have different licenses. See the Software Dependencies section for more information on the external software dependencies.

Linux support is currently experimental and while it is possible to compile the SDK it has not been fully tested so you may run into issues.

## Building the Source in the Source Distribution

When you have all the prerequisites in place and the environment variables set (see Install Prerequisites above), use

```bash
cd <royale-asjs.dir>
ant all (to clone upstream repos, build them and then Royale)
```

On subsequent builds, you can just run

```bash
ant main (or just ant since the default target is main)
```

To clean the build, of everything other than the downloaded third-party dependencies use

```bash
ant clean
```

To generate a source distribution package and a binary distribution package use

```bash
ant -Dbuild.number=<YYYYMMDD> -Dbuild.noprompt= release
```

The packages can be found in the "out" subdirectory.

To get a brief listing of all the targets type

```bash
ant -projecthelp
```

## Using the Binary Distribution

If you are not interested in SWF output, the binary distribution can just be unzipped into a folder.

If you want SWF output, use NPM. Type:

```bash
sudo npm install flexjs -g
```

# Software Dependencies

The FlexJS framework depends on the Google Closure Library.

# Thanks for using [Apache Royale](http://royale.apache.org). Enjoy!
