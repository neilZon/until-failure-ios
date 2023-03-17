//
//  ResendCode.swift
//  WorkoutLogger
//
//  Created by Neil Viloria on 2023-03-16.
//

import SwiftUI

struct ResendCode: View {
    let workoutLoggerApiService = WorkoutLoggerAPIService(client: WorkoutLoggerAPIClient.client)

    @State
    var email = ""
    @State
    var isLoading = false
    @State
    var error: WorkoutLoggerError?

    @State
    private var sent = false

    func sendCode() {
        isLoading = true
        workoutLoggerApiService.resendEmailVerification(email: email, completion: { result in
            switch result {
            case .success:
                error = nil
                sent = true
            case .failure(let err):
                error = err
                print(error)
                sent = false
            }
            isLoading = false
        })
    }

    var body: some View {
        VStack {
            HStack{
                Text("Resend Verification")
                    .font(.title)
                Spacer()
            }
            Text("Enter in the email of the account you've already created")
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(TappableTextFieldStyle())
            Button(action: {
                if(!sent && !isLoading) {
                    sendCode()
                }
            }, label: {
                HStack {
                    Text(sent ? "Sent" : "Send")
                    if isLoading {
                        ProgressView()
                    }
                    if sent {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
            })
            .buttonStyle(RoundedButton())
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .errorAlert($error, confirm: {})
        .padding()
    }
}
