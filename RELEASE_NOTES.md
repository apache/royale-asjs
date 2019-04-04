Apache Royale 0.9.4
===================

- [Better way to style components: ClassSelectorList](https://github.com/apache/royale-asjs/issues/205)
- [Fixed AMF / RemoteObject Support](https://github.com/apache/royale-asjs/issues/204)
- [Added New Jewel UI Set And First 72 Jewel Themes 12 Colors, Light and Dark (Initial work)](https://github.com/apache/royale-asjs/issues/154)
- [Renamed TextOverflow bead to EllipsisOverflow. It now supports Label elements as well.](https://github.com/apache/royale-asjs/issues/130)
- [Added IEEventAdapterBead](https://github.com/apache/royale-asjs/issues/131)
- [Added Object getter/setter utility functions](https://github.com/apache/royale-asjs/issues/132)
- [Added InfiniteVScroller Bead](https://github.com/apache/royale-asjs/issues/134)
- Initial release of the migration component sets (MXRoyale and SparkRoyale) that have a goal of reducing migration effort for those moving existing Flex applications to Royale.
- Initial release of the Tour de Flex example migrated to Royale via the migration component sets.  This is a work in progress.  You can see latest progress on our [CI server](http://apacheroyaleci.westus2.cloudapp.azure.com:8080/job/TourDeFlexMigration/lastSuccessfulBuild/artifact/examples/mxroyale/tourdeflexmodules/bin/js-debug/index.html)

Known Issues:
 - Users only using Basic components and not MXRoyale or SparkRoyale emulation components should delete 
    frameworks/libs/MXRoyale.swc, frameworks/libs/SparkRoyale.swc, frameworks/js/libs/MXRoyaleJS.swc,
    and frameworks/js/libs/SparkRoyaleJS.swc from their library-paths (or from the file system).

Updates to the RELEASE_NOTES discovered after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.4

Apache Royale 0.9.2
===================

- [Added ApplicationParametersBead and ApplicationParametersCaseInsensitiveBead](https://github.com/apache/royale-asjs/issues/129)
- Added virtual item renderer management for fixed row height vertical lists.
- Added Menu and MenuBar
- Added DividedBox
- Many CSS default values are now in the basic.css theme.
- Theme support. Now compiler will copy all resources in "assets" folder to target
- Added JSON2ASVO, a utility that creates AS classes from a JSON result
- Added JSONReviver, a class that converts JSON to AS classes sort of like AMF
- Added HScrollViewport
- Added VScrollViewport
- Fixed bugs in XML parsing and converting back to strings
  - https://github.com/apache/royale-asjs/issues/120
  - https://github.com/apache/royale-asjs/issues/121
  - https://github.com/apache/royale-asjs/issues/122
  - https://github.com/apache/royale-asjs/issues/123
- Fixed Maven distribution so you can use in IDEs like VSCode, Moonshine and more.
  - https://github.com/apache/royale-asjs/issues/125

Updates to the RELEASE_NOTES discovered after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.2

Apache Royale 0.9.1
===================

- The ASDoc example was upgraded to look better, show events, and provide permalinks.

Updates to the RELEASE_NOTES discovered after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.1

Apache Royale 0.9.0
===================

Apache Royale is an SDK that provides the capability to cross-compile MXML 
and ActionScript applications to HTML/JS/CSS so they can run in a browser
without Flash.

Apache Royale was previously released by the Apache Flex project.  You can
see RELEASE_NOTES for earlier releases in the Apache Flex releases.

Updates to the RELEASE_NOTES discovered after this file was packaged into the release artifacts can be found here:

https://github.com/apache/royale-asjs/wiki/Release-Notes-0.9.0

Please report new issues to our bugbase at:

    https://github.com/apache/royale-asjs/issues

                                          The Apache Royale Project
                                          <http://royale.apache.org/>
