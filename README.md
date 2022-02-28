# memehampton

# Adding packages

1. Navigate to https://pub.dev/
2. Search for the package you would like to install.
3. Select the **installing** tab.
4. Copy the `flutter pub add ...` command.
5. Run the command in your terminal.

To use the same packages in a new Flutter project, run the following commands:
```
flutter pub add flex_color_scheme
flutter pub add google_fonts
flutter pub add firebase_core
flutter pub add cloud_firestore
flutter pub add firebase_storage
flutter pub add firebase_auth
flutter pub add flutterfire_ui
flutter pub add animations
flutter pub add go_router
flutter pub add image_picker
```

# Setting up Firebase

```
dart pub global activate flutterfire_cli

flutterfire configure
```

# Firebase Storage CORS

`gsutil cors set cors.json gs://<your-cloud-storage-bucket>`

https://firebase.google.com/docs/storage/web/download-files#cors_configuration


# Finding a Color Scheme

https://rydmike.com/flexcolorschemeV4Tut5/