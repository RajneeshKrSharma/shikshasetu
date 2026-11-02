package com.unique.shiksha_setu

import android.content.ContentValues
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "shiksha_setu/external_copy",
        ).setMethodCallHandler { call, result ->
            if (call.method != "save") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val path = call.argument<String>("path")
            val name = call.argument<String>("name")
            if (path == null || name == null) {
                result.error("args", "path and name are needed", null)
                return@setMethodCallHandler
            }
            try {
                result.success(saveToDownloads(File(path), name))
            } catch (e: Exception) {
                result.error("save", e.message, null)
            }
        }
    }

    /**
     * Copies [source] to Download/ShikshaSetu/[name], replacing the copy this
     * app wrote before. A file made this way stays when the app is removed.
     * Returns where it was put.
     */
    private fun saveToDownloads(source: File, name: String): String {
        val folder = "${Environment.DIRECTORY_DOWNLOADS}/ShikshaSetu/"
        val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
        val resolver = contentResolver

        // The copy this install made earlier (only its own files are visible).
        var target: Uri? = null
        resolver.query(
            collection,
            arrayOf(MediaStore.Downloads._ID),
            "${MediaStore.Downloads.DISPLAY_NAME} = ? AND " +
                "${MediaStore.Downloads.RELATIVE_PATH} = ?",
            arrayOf(name, folder),
            null,
        )?.use { c ->
            if (c.moveToFirst()) {
                target = Uri.withAppendedPath(collection, c.getLong(0).toString())
            }
        }
        if (target == null) {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, name)
                put(MediaStore.Downloads.MIME_TYPE, "application/json")
                put(MediaStore.Downloads.RELATIVE_PATH, folder)
            }
            target = resolver.insert(collection, values)
        }
        val uri = target ?: throw IllegalStateException("could not create the file")
        // "wt": write, and cut the old contents.
        resolver.openOutputStream(uri, "wt")!!.use { out ->
            source.inputStream().use { it.copyTo(out) }
        }
        return "$folder$name"
    }
}
