# App-level R8 rules. Library-specific rules live next to the code that needs them
# (consumer-rules.pro in each module); Retrofit, OkHttp, Gson, Room, Hilt and Navigation ship
# their own consumer rules.

# Keep line numbers for readable crash reports, but hide the original file names.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
