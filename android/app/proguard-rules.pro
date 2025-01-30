# Сохраняем аннотации ErrorProne
-keepattributes *Annotation*

# Исключаем Tink (flutter_secure_storage использует его)
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Исключаем javax.annotation
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

# Исключаем Google ErrorProne
-keep class com.google.errorprone.annotations.** { *; }
-dontwarn com.google.errorprone.annotations.**

# Исключаем GuardedBy
-keep class javax.annotation.concurrent.** { *; }
-dontwarn javax.annotation.concurrent.**
