//
//  ContentView.swift
//  BetterRest
//
//  Created by Leo Torres Neyra on 17/12/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 0
    
    @State private var alertTitle = ""
    //@State private var alertMessage = ""
    
    /** Autocalculate variable for bedtime */
    private var alertMessage: String {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeAmount)))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        }catch {
            return "Sorry, there was a problem calculating your bedtime"
        }
    }
    
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack{
            Form{
                /** Using Sections instead of VStack */
                //VStack (alignment: .leading, spacing: 0) {
                Section{
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.subheadline)
                }
                
                //VStack (alignment: .leading, spacing: 0) {
                Section{
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        .font(.subheadline)
                }
                
                //VStack (alignment: .leading, spacing: 0) {
                Section{
                    Picker("Cups of cofee", selection: $coffeAmount){
                        ForEach(0...20, id: \.self){
                            Text("^[\($0) cup](inflect: true)")
                        }
                        
                    }
                    //Stepper("^[\(coffeAmount) cup](inflect: true)", value: $coffeAmount, in: 0...20)
                } header: {
                    Text("Daily cofee intake")
                        .font(.subheadline)
                }
                
                Section{
                    Text(alertMessage)
                }header: {
                    Text("Your ideal bedtime is...")
                        .font(.subheadline)
                }
                
            }
            .navigationTitle("Better Rest")
            /** Using a button in a toolbar for calculate bedtime */
            /*.toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert){
                Button("OK") { }
            }message: {
                Text(alertMessage)
            }*/
        }
    }
    /** Function for the button "Calculate" in the toolbar */
    /*func calculateBedTime() {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeAmount)))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true
    }*/
}

#Preview {
    ContentView()
}
