# ww_api.model.PatientHospitalDetailOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**type** | **String** |  | 
**address** | **String** |  | 
**city** | **String** |  | 
**lat** | **String** |  | 
**lng** | **String** |  | 
**phone** | **String** |  | 
**opdHours** | **String** |  | 
**photoUrl** | **String** | Works for 5 minutes | [optional] 
**distanceKm** | **num** | None when no location was given | [optional] 
**doctorCount** | **int** |  | 
**departments** | **List&lt;String&gt;** |  | 
**doctors** | [**List&lt;PatientDoctorOut&gt;**](PatientDoctorOut.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


