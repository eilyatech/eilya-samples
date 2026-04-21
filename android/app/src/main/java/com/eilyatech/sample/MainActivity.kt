package com.eilyatech.sample

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.eilyatech.sample.databinding.ActivityMainBinding
import io.eilya.otp.EilyaOtp
import io.eilya.otp.EilyaOtpConfig
import io.eilya.otp.Locale
import io.eilya.otp.OtpLength
import io.eilya.chat.EilyaChat
import io.eilya.chat.EilyaChatConfig
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private var currentPipelineId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // ─── Initialize Eilya OTP SDK ─────────────────────────────────────
        EilyaOtp.init(
            context = this,
            apiKey = "ek_test_your_api_key_here", // Replace with your API key
            config = EilyaOtpConfig(
                locale = Locale.AR,
                otpLength = OtpLength.SIX,
                expirySeconds = 300,
            ),
        )

        // ─── Initialize Eilya Chat SDK ────────────────────────────────────
        EilyaChat.init(
            context = this,
            apiKey = "eck_test_your_api_key_here", // Replace with your API key
            config = EilyaChatConfig(),
        )

        setupOtp()
        setupChat()
    }

    // ── OTP ──────────────────────────────────────────────────────────────

    private fun setupOtp() {
        binding.btnRequestOtp.setOnClickListener {
            val phone = binding.inputPhone.text.toString().trim()
            if (phone.isEmpty()) {
                toast("Enter a phone number")
                return@setOnClickListener
            }

            lifecycleScope.launch {
                binding.btnRequestOtp.isEnabled = false
                binding.txtOtpStatus.text = "Sending OTP..."

                EilyaOtp.requestOtp(phone)
                    .onSuccess { pipeline ->
                        currentPipelineId = pipeline.pipelineId
                        binding.txtOtpStatus.text =
                            "OTP sent via ${pipeline.channelUsed}\nPipeline: ${pipeline.pipelineId}"
                        binding.layoutVerify.visibility = android.view.View.VISIBLE
                    }
                    .onFailure { error ->
                        binding.txtOtpStatus.text = "Error: ${error.message}"
                    }

                binding.btnRequestOtp.isEnabled = true
            }
        }

        binding.btnVerifyOtp.setOnClickListener {
            val code = binding.inputOtpCode.text.toString().trim()
            val pipelineId = currentPipelineId

            if (code.isEmpty() || pipelineId == null) {
                toast("Enter the OTP code")
                return@setOnClickListener
            }

            lifecycleScope.launch {
                binding.btnVerifyOtp.isEnabled = false
                binding.txtOtpStatus.text = "Verifying..."

                EilyaOtp.verifyOtp(pipelineId, code)
                    .onSuccess { result ->
                        binding.txtOtpStatus.text =
                            "Verified!\nToken: ${result.authToken}\nPhone: ${result.phone}"
                    }
                    .onFailure { error ->
                        binding.txtOtpStatus.text = "Failed: ${error.message}"
                    }

                binding.btnVerifyOtp.isEnabled = true
            }
        }
    }

    // ── Chat ─────────────────────────────────────────────────────────────

    private fun setupChat() {
        binding.btnSendChat.setOnClickListener {
            val message = binding.inputChatMessage.text.toString().trim()
            if (message.isEmpty()) {
                toast("Enter a message")
                return@setOnClickListener
            }

            lifecycleScope.launch {
                binding.btnSendChat.isEnabled = false
                binding.txtChatStatus.text = "Sending..."

                // Create session if not exists
                if (EilyaChat.currentSession == null) {
                    val sessionResult = EilyaChat.createSession()
                    if (sessionResult.isFailure) {
                        binding.txtChatStatus.text =
                            "Session error: ${sessionResult.exceptionOrNull()?.message}"
                        binding.btnSendChat.isEnabled = true
                        return@launch
                    }
                }

                EilyaChat.sendMessage(message)
                    .onSuccess { reply ->
                        binding.txtChatStatus.text =
                            "You: $message\n\nBot: ${reply.content}"
                        binding.inputChatMessage.text?.clear()
                    }
                    .onFailure { error ->
                        binding.txtChatStatus.text = "Error: ${error.message}"
                    }

                binding.btnSendChat.isEnabled = true
            }
        }
    }

    private fun toast(msg: String) = Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
}
