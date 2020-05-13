# Apache Royale&trade;
[![Build Status](https://builds.apache.org/job/Royale-asjs/lastSuccessfulBuild/badge/icon)](https://builds.apache.org/job/Royale-asjs/)

The Apache Royale project is developing a next-generation of the Apache Flex&trade; SDK: . Royale has the goal of allowing applications developed in MXML and ActionScript to not only run in the Flash/AIR runtimes, but also to run natively in the browser without Flash, on mobile devices as a PhoneGap/Cordova application, and in embedded JS environments such as Chromium Embedded Framework. Royale has the potential to allow your MXML and ActionScript code to run in even more places than Flash currently does.

For detailed information about using Royale, visit:

<https://apache.github.io/royale-docs/>

For more information about the Apache Royale project, visit:

<https://royale.apache.org>

# Getting Royale

Getting the source code from GitHub is the recommended way to get Royale. You can check out the source via git using the following commands:

```bash
git clone https://github.com/apache/royale-asjs.git royale-asjs
cd royale-asjs
git checkout develop
```

You may also use a precompiled binary convenience package to develop Royale applications using your favorite IDE. In addition to that, Royale is available as Maven artifacts and through Node Package Manager (NPM).

# Building Royale

## Prerequisites

Before building Royale you must install the following software and set the corresponding environment variables using absolute file paths (relative paths will result in build errors). The set of prerequisites is different depending on whether you want to compile your projects to SWF or not.  If you want SWF output, set up the environment variables per the instructions below, then skip to the next section (Additional Prerequisites For SWF Output)

### Java

Royale requires Java SDK 1.8 or greater to be installed on your computer. For more information on installing the Java SDK, see:

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>

- **Environment variable**

  Set the **JAVA_HOME** environment variable to the Java SDK installation path.

- **PATH**

  Add the bin directory of **JAVA_HOME** to the PATH.

  On Windows, set PATH to
  ```batch
  PATH=%PATH%;%JAVA_HOME%\bin
  ```

  On a Mac, set PATH to
  ```bash
  export PATH="$PATH:$JAVA_HOME/bin"
  ```

### Ant

Royale requires Ant 1.8 or greater to be installed on your computer.

For more information on installing Ant, see:

<http://ant.apache.org/>

- **Environment variable**

  Set the **ANT_HOME** environment variable to the Ant installation path.

- **PATH**

  Add the bin directory of **ANT_HOME** to the PATH.

  On Windows, set PATH to
  ```batch
  PATH=%PATH%;%ANT_HOME%\bin
  ```

  On a Mac, set PATH to
  ```bash
  export PATH="$PATH:$ANT_HOME/bin"
  ```

## Additional Prerequisites For SWF Output

### *playerglobal.swc*

The Adobe Flash Player *playerglobal.swc* (version 11.1) can be downloaded from:

<http://fpdownload.macromedia.com/get/flashplayer/installers/archive/playerglobal/playerglobal11_1.swc>

First, create the following directory structure:

*[root directory]/player/11.1/*

Next, rename the downloaded SWC to '*playerglobal.swc*' and place it in the above directory.

- **Environment variable**

  Set **PLAYERGLOBAL_HOME** environment variable to the absolute path of the player directory, not including the version subdirectory (i.e. '*[root directory]/player*').

Other, more recent versions of Adobe Flash Player *playerglobal.swc* can be downloaded from http://<i></i>download.macromedia.com/get/flashplayer/updaters/[version.major]/playerglobal[version.major]\_[version.minor].swc (e.g. <http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc>). These versions can be used with Royale, but not all have been fully tested.


### Flash Player Content Debugger

The Flash Player Content Debugger can be found here:

<http://www.adobe.com/support/flashplayer/downloads.html>

This version of Royale was certified for use with Flash Player 11.1, and is compatible with version 10.2 and up. It has been tested with version 16.0 on Windows and Mac. It has been compiled, but not fully tested, with other Flash Player versions. It has not been fully tested on Linux.

- **Environment variable**

  On Windows, set **FLASHPLAYER_DEBUGGER** to the absolute path including the filename of the Flash Player Projector Content Debugger executable (e.g. '*FlashPlayerDebugger.exe*'). Note: the filename of Flash Player Content Debugger can differ slightly between versions. Adjust your path accordingly.

  On the Mac, set **FLASHPLAYER_DEBUGGER** to the absolute path of '*Flash Player.app/Contents/MacOS/Flash Player Debugger*'

  On Linux, set **FLASHPLAYER_DEBUGGER** to the absolute path of '*flashplayerdebugger*'.

### Adobe AIR Integration Kit (optional, for SWF output only)

This version of Apache Royale was certified for use with Adobe AIR 16 and is compatible with version 3.1 and up. The Adobe AIR integration kit can be downloaded from:

Windows: <http://airdownload.adobe.com/air/win/download/16.0/AdobeAIRSDK.zip>

Mac: <http://airdownload.adobe.com/air/mac/download/16.0/AdobeAIRSDK.tbz2>

Linux: <http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRSDK.tbz2>

After you download the AIR SDK, unzip it and place it in a directory of your choice.

- **Environment variable**

  Set **AIR_HOME** to the absolute path of the AIR SDK directory.

## Building the source

Linux support is currently experimental and while it is possible to compile the SDK it has not been fully tested.

Royale requires code from several other Apache Royale git repositories. To get these repositories, change to the repository root ('*royale-asjs*') and run:

```bash
ant all
```

This will clone the repositories, checkout the develop branches then build those repositories in the correct order.

Some more helpful commands:

- To rebuild, run:

  ```bash
  ant
  ```

- To clean the build, of everything other than the downloaded third-party dependencies, run:

  ```bash
  ant clean
  ```

- To generate a source distribution package and a binary distribution package, run:

  ```bash
  ant -Dbuild.number=<YYYYMMDD> -Dbuild.noprompt= release
  ```

  The packages can be found in the "out" subdirectory.

- To get a brief listing of all the targets, run:

  ```bash
  ant -projecthelp
  ```

## Using the Binary Distribution

If you are not interested in SWF output, the binary distribution can just be unzipped into a folder.

If you want SWF output, use NPM. Run:

- Mac
```bash
sudo npm install @apache-royale/royale-js -g
```
or for both JS and SWF output:

```bash
sudo npm install @apache-royale/royale-js-swf -g

- Windows
```bash
npm install @apache-royale/royale-js -g
```
or for both JS and SWF output:
```bash
npm install @apache-royale/royale-js-swf -g
```


# Using Royale

In order to get started using Royale, you are invited to follow along with the [Quick Start Guide](https://github.com/apache/royale-asjs/wiki/Quick-Start).

### Thanks for using [Apache Royale](https://royale.apache.org). Enjoy!
