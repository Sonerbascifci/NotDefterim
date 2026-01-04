# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Firebase Auth
-keepattributes Signature
-keepattributes *Annotation*

# Cloud Firestore
-keep class com.google.cloud.** { *; }
-dontwarn com.google.cloud.**

# Google Play Core (required for some Firebase features)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Google Analytics
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Gson (if used)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Suppress warnings for missing classes
-dontwarn com.google.android.play.core.**
-dontwarn org.checkerframework.**
-dontwarn javax.annotation.**

