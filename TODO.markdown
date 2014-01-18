# Fetch the endpoint URLs
curl http://10.0.0.1:64321/DmsRmtDesc.xml|xmllint --format -

# take a picture
curl -v -X POST -H "Content-Type: application/json" -d '{"method":"actTakePicture", "params":[], "id":1, "version":"1.0"}' http://10.0.0.1:10000/sony/camera

# TODO: Test private APIs from http://chdk.setepontos.com/index.php?topic=10736.0

camera/setFlashMode
camera/getFlashMode
camera/getSupportedFlashMode
camera/getAvailableFlashMode
camera/setExposureCompensation
camera/getExposureCompensation
camera/getSupportedExposureCompensation
camera/getAvailableExposureCompensation
camera/setSteadyMode
camera/getSteadyMode
camera/getSupportedSteadyMode
camera/getAvailableSteadyMode
camera/setViewAngle
camera/getViewAngle
camera/getSupportedViewAngle
camera/getAvailableViewAngle
camera/setMovieQuality
camera/getMovieQuality
camera/getSupportedMovieQuality
camera/getAvailableMovieQuality
camera/setFocusMode
camera/getFocusMode
camera/getSupportedFocusMode
camera/getAvailableFocusMode
camera/setStillSize
camera/getStillSize
camera/getSupportedStillSize
camera/getAvailableStillSize
camera/setBeepMode
camera/getBeepMode
camera/getSupportedBeepMode
camera/getAvailableBeepMode
camera/setCameraFunction
camera/getCameraFunction
camera/getSupportedCameraFunction
camera/getAvailableCameraFunction
camera/setLiveviewSize
camera/getLiveviewSize
camera/getSupportedLiveviewSize
camera/getAvailableLiveviewSize
camera/setTouchAFPosition
camera/getTouchAFPosition
camera/cancelTouchAFPosition
camera/setFNumber
camera/getFNumber
camera/getSupportedFNumber
camera/getAvailableFNumber
camera/setShutterSpeed
camera/getShutterSpeed
camera/getSupportedShutterSpeed
camera/getAvailableShutterSpeed
camera/setIsoSpeedRate
camera/getIsoSpeedRate
camera/getSupportedIsoSpeedRate
camera/getAvailableIsoSpeedRate
camera/setExposureMode
camera/getExposureMode
camera/getSupportedExposureMode
camera/getAvailableExposureMode
camera/setWhiteBalance
camera/getWhiteBalance
camera/getSupportedWhiteBalance
camera/getAvailableWhiteBalance
camera/setProgramShift
camera/getSupportedProgramShift
camera/getStorageInformation
camera/startLiveviewWithSize
camera/startIntervalStillRec
camera/stopIntervalStillRec
camera/actFormatStorage
system/setCurrentTime
