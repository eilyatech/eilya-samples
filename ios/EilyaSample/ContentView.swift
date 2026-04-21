import SwiftUI
import EilyaOTP
import EilyaChat

struct ContentView: View {
    // OTP state
    @State private var phone = ""
    @State private var otpCode = ""
    @State private var pipelineId: String?
    @State private var otpStatus = ""
    @State private var showVerify = false

    // Chat state
    @State private var chatMessage = ""
    @State private var chatStatus = ""
    @State private var hasSession = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                Text("Eilya SDK Sample")
                    .font(.title.bold())
                Text("Test OTP and Chat SDKs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // ── OTP Section ──────────────────────────────────
                VStack(alignment: .leading, spacing: 12) {
                    Text("OTP Verification")
                        .font(.headline)
                        .foregroundColor(.purple)

                    TextField("Phone number (e.g. +201012345678)", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)

                    Button("Request OTP") {
                        Task { await requestOtp() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)

                    if showVerify {
                        HStack {
                            TextField("Enter OTP code", text: $otpCode)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)

                            Button("Verify") {
                                Task { await verifyOtp() }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        }
                    }

                    if !otpStatus.isEmpty {
                        Text(otpStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontDesign(.monospaced)
                    }
                }

                Divider()

                // ── Chat Section ─────────────────────────────────
                VStack(alignment: .leading, spacing: 12) {
                    Text("AI Chat")
                        .font(.headline)
                        .foregroundColor(.blue)

                    HStack {
                        TextField("Type a message...", text: $chatMessage)
                            .textFieldStyle(.roundedBorder)

                        Button("Send") {
                            Task { await sendChat() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }

                    if !chatStatus.isEmpty {
                        Text(chatStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontDesign(.monospaced)
                    }
                }
            }
            .padding()
        }
    }

    // ── OTP Functions ────────────────────────────────────────────

    func requestOtp() async {
        guard !phone.isEmpty else {
            otpStatus = "Enter a phone number"
            return
        }
        otpStatus = "Sending OTP..."

        do {
            let pipeline = try await EilyaOtp.shared.requestOTP(phone: phone)
            pipelineId = pipeline.pipelineId
            otpStatus = "OTP sent via \(pipeline.channelUsed)\nPipeline: \(pipeline.pipelineId)"
            showVerify = true
        } catch {
            otpStatus = "Error: \(error.localizedDescription)"
        }
    }

    func verifyOtp() async {
        guard let pid = pipelineId, !otpCode.isEmpty else {
            otpStatus = "Enter the OTP code"
            return
        }
        otpStatus = "Verifying..."

        do {
            let result = try await EilyaOtp.shared.verifyOTP(pipelineId: pid, otp: otpCode)
            otpStatus = "Verified!\nToken: \(result.authToken)\nPhone: \(result.phone)"
        } catch {
            otpStatus = "Failed: \(error.localizedDescription)"
        }
    }

    // ── Chat Functions ───────────────────────────────────────────

    func sendChat() async {
        guard !chatMessage.isEmpty else {
            chatStatus = "Enter a message"
            return
        }
        let msg = chatMessage
        chatMessage = ""
        chatStatus = "Sending..."

        do {
            // Create session if not exists
            if !hasSession {
                _ = try await EilyaChat.shared.createSession()
                hasSession = true
            }

            let reply = try await EilyaChat.shared.sendMessage(msg)
            chatStatus = "You: \(msg)\n\nBot: \(reply.content)"
        } catch {
            chatStatus = "Error: \(error.localizedDescription)"
        }
    }
}

// ── App Entry Point ──────────────────────────────────────────────

@main
struct EilyaSampleApp: App {
    init() {
        // Initialize Eilya OTP — replace with your API key
        EilyaOtp.shared.configure(apiKey: "ek_test_your_api_key_here")

        // Initialize Eilya Chat — replace with your API key
        EilyaChat.shared.configure(apiKey: "eck_test_your_api_key_here")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
