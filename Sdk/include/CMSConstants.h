//
//  Copyright (c) 2013-2016 EMC Corporation.  All rights reserved.
//

// filters
extern NSString *const CMSFilterAdaptiveBinary;
extern NSString *const CMSFilterGrayscale;
extern NSString *const CMSFilterPerspective;
extern NSString *const CMSFilterCrop;
extern NSString *const CMSFilterResize;
extern NSString *const CMSFilterRotation;
extern NSString *const CMSFilterBrightness;
extern NSString *const CMSFilterContrast;
extern NSString *const CMSFilterRemoveNoise;

// filter parameters
extern NSString *const CMSFilterParamAdaptiveBinaryForce;
extern NSString *const CMSFilterParamAdaptiveBinaryBlackness;
extern NSString *const CMSFilterParamCropPadding;
extern NSString *const CMSFilterParamCropRectangle;
extern NSString *const CMSFilterParamResizeWidth;
extern NSString *const CMSFilterParamResizeHeight;
extern NSString *const CMSFilterParamRotationDegree;
extern NSString *const CMSFilterParamBrightnessScale;
extern NSString *const CMSFilterParamContrastScale;
extern NSString *const CMSFilterParamNoiseSize;
extern NSString *const CMSFilterParamPerspectivePoints;

// measureQuality parameters
extern NSString *const CMSMeasureGlare;
extern NSString *const CMSMeasureQuadrilateral;
extern NSString *const CMSMeasurePerspective;

// save properties
extern NSString *const CMSSaveDpiX;
extern NSString *const CMSSaveDpiY;
extern NSString *const CMSSaveJpgQuality;
extern NSString *const CMSSaveToGallery;
extern NSString *const CMSSaveToGalleryCompletionTarget;
extern NSString *const CMSSaveToGalleryCompletionSelector;
extern NSString *const CMSSaveToGalleryContext;

// save encoding
extern NSString *const CMSSaveJpg;
extern NSString *const CMSSaveTiff;
extern NSString *const CMSSavePng;

// image properties
extern NSString *const CMSImagePropertyWidth;
extern NSString *const CMSImagePropertyHeight;
extern NSString *const CMSImagePropertyChannels;
extern NSString *const CMSImagePropertyBitsPerPixel;

// takePicture parameters
extern NSString * const CMSTakePictureEdgeLabel;
extern NSString * const CMSTakePictureCenterLabel;
extern NSString * const CMSTakePictureCaptureLabel;
extern NSString * const CMSTakePictureSensors;
extern NSString * const CMSTakePictureCaptureDelay;
extern NSString * const CMSTakePictureCaptureTimeout;
extern NSString * const CMSTakePictureGuidelines;
extern NSString * const CMSTakePictureCancelButton;
extern NSString * const CMSTakePictureTorchButton;
extern NSString * const CMSTakePictureTorch;
extern NSString * const CMSTakePictureOptimalConditions;
extern NSString * const CMSTakePictureMotionSensitivity;
extern NSString * const CMSTakePictureContext;
extern NSString * const CMSTakePictureImmediately;
extern NSString * const CMSTakePictureCrop;
extern NSString * const CMSTakePictureCropOk;
extern NSString * const CMSTakePictureCropWarning;
extern NSString * const CMSTakePictureCropProcessing;
extern NSString * const CMSTakePictureQualityMeasures;
extern NSString * const CMSTakePictureCaptureWindow;
extern NSString * const CMSTakePictureReturnMode;
extern NSString * const CMSTakePictureSaveTo;

// takePicture default parameter values
extern const int CMSTakePictureLabelMaxLength;
extern NSString * const CMSTakePictureSensorsDefault;
extern const CGFloat CMSTakePictureMotionSensorDefault;
extern const CGFloat CMSTakePictureMotionSensorMin;
extern const CGFloat CMSTakePictureMotionSensorMax;
extern const int CMSTakePictureCaptureTimeoutDefault;
extern const int CMSTakePictureCaptureDelayDefault;
extern const CGSize CMSTakePictureCropVisible;

// takePicture data return modes
extern const int CMSTakePictureReturnCallback;
extern const int CMSTakePictureReturnFile;
extern const int CMSTakePictureReturnLoad;

// takePicture return values for imageDidCancelTakePicture()
extern const int CMSCancelReasonButton;
extern const int CMSCancelReasonTimeout;
extern const int CMSCancelReasonError;
extern const int CMSCancelReasonPermission;
extern const int CMSCancelReasonBackground;

// continuousCapture specific keys
extern NSString * const CMSCaptureFrameDelay;

// continousCapture default parameter values
extern const int CMSCaptureFrameDelayDefault;

// capture modes for UI customization
extern const int CMSCaptureModeIdle;
extern const int CMSCaptureModeCapturing;

// sensor types for customization
extern const int CMSSensorMovement;
extern const int CMSSensorFocus;
extern const int CMSSensorQuality;

// quality sensor data arguments
extern NSString * const CMSQualityCorners;

// additional continuous capture callback data parameters
extern NSString * const CMSCaptureSimilarity;
extern NSString * const CMSCaptureSavedFileName;

// NSError values
extern NSString * const CMSErrorDomain;

extern const NSInteger CMSErrorUnknown;
extern const NSInteger CMSErrorDeviceInit;
extern const NSInteger CMSErrorEncode;
extern const NSInteger CMSErrorSave;
extern const NSInteger CMSErrorDecode;
extern const NSInteger CMSErrorLoad;
extern const NSInteger CMSErrorNoImage;
extern const NSInteger CMSErrorBadDimensions;
extern const NSInteger CMSErrorOutOfMemory;
extern const NSInteger CMSErrorUndoFailed;
extern const NSInteger CMSErrorUndoDisabled;
extern const NSInteger CMSErrorUndoMissing;
extern const NSInteger CMSErrorCallInProgress;
extern const NSInteger CMSErrorInvalidArgument;
extern const NSInteger CMSErrorTimeout;
extern const NSInteger CMSErrorTakePictureNotAllowedInProgress;

// showQuadrilateralCrop keys
extern NSString * const CMSCropContext;
extern NSString * const CMSCropColor;
extern NSString * const CMSCropLineWidth;
extern NSString * const CMSCropCircleRadius;
extern NSString * const CMSCropShadeBackground;

// showQuadrilateralCrop return values for cropCompleted
extern const int CMSCropReasonCropped;
extern const int CMSCropReasonCancelled;
extern const int CMSCropReasonError;

// barcodes
extern NSString *const CMSBarcodeConfidence;
extern NSString *const CMSBarcodePosition;
extern NSString *const CMSBarcodeText;
extern NSString *const CMSBarcodeType;

extern NSString *const CMSBarcodeTypeAll;
extern NSString *const CMSBarcodeTypeUnknown;
extern NSString *const CMSBarcodeTypeIndustry2of5;
extern NSString *const CMSBarcodeTypeInterleaved2of5;
extern NSString *const CMSBarcodeTypeIATA2of5;
extern NSString *const CMSBarcodeTypeDatalogic2of5;
extern NSString *const CMSBarcodeTypeInverted2of5;
extern NSString *const CMSBarcodeTypeBCDMatrix;
extern NSString *const CMSBarcodeTypeMatrix2of5;
extern NSString *const CMSBarcodeTypeCode32;
extern NSString *const CMSBarcodeTypeCode39;
extern NSString *const CMSBarcodeTypeCodabar;
extern NSString *const CMSBarcodeTypeCode93;
extern NSString *const CMSBarcodeTypeCode128;
extern NSString *const CMSBarcodeTypeEAN13;
extern NSString *const CMSBarcodeTypeEAN8;
extern NSString *const CMSBarcodeTypeUPCA;
extern NSString *const CMSBarcodeTypeUPCE;
extern NSString *const CMSBarcodeTypeAdd5;
extern NSString *const CMSBarcodeTypeAdd2;
extern NSString *const CMSBarcodeTypeEAN128;
extern NSString *const CMSBarcodeTypePatchcode;
extern NSString *const CMSBarcodeTypePostnet;
extern NSString *const CMSBarcodeTypePDF417;
extern NSString *const CMSBarcodeTypeDatamatrix;
extern NSString *const CMSBarcodeTypeCode93Extended;
extern NSString *const CMSBarcodeTypeCode39Extended;
extern NSString *const CMSBarcodeTypeQRCode;
extern NSString *const CMSBarcodeTypeIntelligentMail;
extern NSString *const CMSBarcodeTypeRoyalPost4State;
extern NSString *const CMSBarcodeTypeAustralianPost4State;
extern NSString *const CMSBarcodeTypeAztec;
extern NSString *const CMSBarcodeTypeGS1DataBar;
