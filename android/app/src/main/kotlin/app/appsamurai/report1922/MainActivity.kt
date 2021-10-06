package app.appsamurai.report1922

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.appsamurai.report1922"
    private var result: MethodChannel.Result? = null
    private var lifeCycle: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    this.result = result

                    when (call.method) {
                        "requestLifeCycle" -> {
                            result.success(lifeCycle)
                        }
                        else -> {
                            result.notImplemented()
                        }
                    }
                }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleLifeCycle("onCreate")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleLifeCycle("onNewIntent")
    }

    override fun onPause() {
        super.onPause()
        handleLifeCycle("onPause")
    }

    override fun onStop() {
        super.onStop()
        handleLifeCycle("onStop")
    }

    private fun handleLifeCycle(state: String?) {
        if (state != null) {
            lifeCycle = state
        }
    }

}