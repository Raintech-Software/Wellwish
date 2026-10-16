# ww_api.model.BookingTimesOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | [**DateTime**](DateTime.md) | The date the times are for | 
**times** | [**List&lt;DateTime&gt;**](DateTime.md) | Times that can be picked, soonest first | 
**days** | [**List&lt;BookingDayOut&gt;**](BookingDayOut.md) | Every date in the booking window | 
**timeStepMin** | **int** |  | 
**travelBufferMin** | **int** | Suggested pickup = doctor appointment minus this | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


