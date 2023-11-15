# Install script for directory: /mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/mnt/d/code/Games202/myhw2/prt/build/ext_build/openexr/OpenEXR/IlmImf/libIlmImf.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/OpenEXR" TYPE FILE FILES
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfForward.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfExport.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfBoxAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCRgbaFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChannelList.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChannelListAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompressionAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDoubleAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFloatAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFrameBuffer.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfHeader.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfIO.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfIntAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLineOrderAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMatrixAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOpaqueAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOutputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgbaFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStringAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfVecAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfHuf.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfWav.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLut.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfArray.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompression.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLineOrder.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfName.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPixelType.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfVersion.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfXdr.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfConvert.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPreviewImage.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPreviewImageAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChromaticities.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChromaticitiesAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfKeyCode.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfKeyCodeAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTimeCode.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTimeCodeAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRational.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRationalAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFramesPerSecond.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStandardAttributes.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfEnvmap.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfEnvmapAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInt64.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgba.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTileDescription.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTileDescriptionAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledInputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledOutputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledRgbaFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgbaYca.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTestFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfThreading.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfB44Compressor.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStringVectorAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiView.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfAcesFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiPartOutputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfGenericOutputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiPartInputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfGenericInputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPartType.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPartHelper.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOutputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledOutputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledInputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineOutputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineOutputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineInputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineInputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledInputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledInputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledOutputFile.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledOutputPart.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepFrameBuffer.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepCompositing.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompositeDeepScanLine.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfNamespace.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMisc.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepImageState.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepImageStateAttribute.h"
    "/mnt/d/code/Games202/myhw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFloatVectorAttribute.h"
    )
endif()

