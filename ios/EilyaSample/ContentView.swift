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
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
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
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
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
            let pipeline = try await EilyaOtp.shared.requestOTP(phoneNumber: phone)
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
            otpStatus = "Verified successfully\nPhone: \(result.phone ?? "")"
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
        // Supply real values in the Xcode scheme environment; never commit them.
        let environment = ProcessInfo.processInfo.environment
        let otpApiKey = environment["EILYA_OTP_API_KEY"]
            ?? "ek_test_000000000000000000000000000000000000000000000000"
        let chatEmbedToken = environment["EILYA_CHAT_EMBED_TOKEN"]
            ?? "ew_000000000000000000000000000000000000000000000000"
        EilyaOtp.shared.configure(apiKey: otpApiKey)

        EilyaChat.shared.configure(embedToken: chatEmbedToken)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
