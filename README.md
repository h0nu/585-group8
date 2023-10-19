Clone game for 585, group 8

Used flutter game-template as a base for the game

Working code is in lib/main.dart

You might need to enable multidex in app/build.gradle

defaultConfig {
    ...

    multiDexEnabled true
}

dependencies {
    ...

    implementation 'com.android.support:multidex:1.0.3'
}
