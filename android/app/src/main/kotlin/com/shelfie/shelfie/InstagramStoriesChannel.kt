package com.shelfie.shelfie

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * `share/instagram` platform channel: shares a rendered PNG to Instagram
 * Stories with the `com.instagram.share.ADD_TO_STORY` intent.
 *
 * Files are exposed through [InstagramFileProvider] (`<cache>/share/`), which
 * is where `ShareExporter` writes them.
 */
class InstagramStoriesChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAvailable" -> result.success(isInstagramInstalled())
            "shareToStory" -> result.success(shareToStory(call))
            else -> result.notImplemented()
        }
    }

    private fun isInstagramInstalled(): Boolean = try {
        activity.packageManager.getPackageInfo(INSTAGRAM_PACKAGE, 0)
        true
    } catch (_: PackageManager.NameNotFoundException) {
        false
    }

    private fun shareToStory(call: MethodCall): Boolean {
        val appId = call.argument<String>("appId") ?: return false
        val background = call.argument<String>("backgroundPath")?.let(::contentUri)
        val sticker = call.argument<String>("stickerPath")?.let(::contentUri)
        if (background == null && sticker == null) return false

        val intent = Intent(ACTION_ADD_TO_STORY).apply {
            putExtra("source_application", appId)
            if (background != null) {
                setDataAndType(background, "image/png")
            } else {
                type = "image/png"
            }
            if (sticker != null) {
                putExtra("interactive_asset_uri", sticker)
                activity.grantUriPermission(
                    INSTAGRAM_PACKAGE,
                    sticker,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION,
                )
            }
            call.argument<String>("topColor")?.let { putExtra("top_background_color", it) }
            call.argument<String>("bottomColor")?.let { putExtra("bottom_background_color", it) }
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        if (activity.packageManager.resolveActivity(intent, 0) == null) return false
        activity.startActivityForResult(intent, 0)
        return true
    }

    private fun contentUri(path: String): Uri = FileProvider.getUriForFile(
        activity,
        "${activity.packageName}.instagramshare",
        File(path),
    )

    companion object {
        private const val CHANNEL = "share/instagram"
        private const val ACTION_ADD_TO_STORY = "com.instagram.share.ADD_TO_STORY"
        private const val INSTAGRAM_PACKAGE = "com.instagram.android"
    }
}

/** Own subclass so the authority can't clash with plugin FileProviders. */
class InstagramFileProvider : FileProvider()
