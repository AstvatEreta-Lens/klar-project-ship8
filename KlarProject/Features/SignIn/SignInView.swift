//
//  SignInView.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/10/25.
//

import SwiftUI

struct SignInView: View {
    private var newAccount : String = "create new account"
    @State private var usserName : String = ""
    @State private var password : String = ""
    
    @State private var isPasswordVisible : Bool = false
    @State private var isError : Bool = false
    
    var body: some View {
            VStack{
                Spacer()
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()
                
                HStack{
                    Text("New to Klar?")
//                        .padding(10)
                    Button(action: {
                        print("Button Create New Account Clicked")
                    }){
                        Text(newAccount)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Email
                VStack{
                    Text("Email")
                    TextField("", text : $usserName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Password
                VStack{
                    Text("Password")
                    HStack{
                        if isPasswordVisible{
                            TextField("", text : $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        else {
                            SecureField("", text : $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Button(action :{
                            isPasswordVisible.toggle()
                        }){
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
                
                Text("wrong password or email, try again")
                    .foregroundColor(.red)
                    .toggleStyle(SwitchToggleStyle())
                
                // Sign In Button
                Button(action: {
                    print("Button Sign In Clicked")
                }){
                    Text("Sign In")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(10)
            }
//            .frame(width: 200)
            .padding(30)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
            .padding(20)
    }
}

#Preview {
    SignInView()
}
