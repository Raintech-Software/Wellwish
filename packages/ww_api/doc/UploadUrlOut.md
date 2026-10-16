# ww_api.model.UploadUrlOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**fileKey** | **String** | Send this with the form after uploading | 
**uploadUrl** | **String** | POST the file here as multipart/form-data: every upload field first, then the file as `file` (/path = on this API). The storage refuses a bigger file. | 
**uploadFields** | **Map&lt;String, String&gt;** | Form fields to send before the file, unchanged (the signed policy) | 
**mime** | **String** |  | 
**maxBytes** | **int** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


