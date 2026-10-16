# ww_api.model.StaffLoginOut

## Load the model package
```dart
import 'package:ww_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**step** | **String** | TOTP_SETUP: first login, show the QR code. TOTP: ask for the code. SIGNED_IN: a trusted browser (v2.16), the tokens below. | 
**challengeToken** | **String** | Empty when SIGNED_IN | [optional] [default to '']
**otpauthUri** | **String** | Only for TOTP_SETUP: encode as QR code | [optional] 
**secret** | **String** | Only for TOTP_SETUP: for typing in by hand | [optional] 
**signedIn** | [**StaffTokenOut**](StaffTokenOut.md) | Only for SIGNED_IN | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


