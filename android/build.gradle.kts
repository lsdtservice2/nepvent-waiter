allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Android-specific settings: compileSdkVersion, buildToolsVersion
subprojects {
    afterEvaluate {
        plugins.withId("com.android.application") {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(36)
                buildToolsVersion = "36.0.0"
            }
        }
        plugins.withId("com.android.library") {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(36)
                buildToolsVersion = "36.0.0"
            }
        }
    }
}

// Set namespace if null
subprojects {
    afterEvaluate {
        extensions.findByName("android")?.let { androidExt ->
            if (androidExt is com.android.build.gradle.BaseExtension && androidExt.namespace == null) {
                androidExt.namespace = project.group.toString()
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
