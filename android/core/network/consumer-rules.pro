# DTOs are (de)serialized reflectively by Gson: keep their fields and constructors.
-keep class ro.profitnet.app.core.network.dto.** { *; }

# Retrofit reads generic signatures and annotations of the API interfaces at runtime.
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations, AnnotationDefault
