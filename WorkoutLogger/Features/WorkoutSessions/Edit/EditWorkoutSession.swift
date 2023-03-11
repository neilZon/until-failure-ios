//
//  EditWorkoutSession.swift
//  WorkoutLogger
//
//  Created by Neil Viloria on 2022-12-08.
//

import SwiftUI

struct EditWorkoutSession: View {
    @Environment(\.presentationMode) var presentationMode

    var workoutSessionId: String
    var end: Date?

    @State private var showSheet = false
    @State private var showFinishWorkoutAlert = false
    @StateObject private var workoutSessionViewModel = WorkoutSessionViewModel(service: WorkoutLoggerAPIService())

    func getPrevExercise(exerciseRoutineId: String) -> PrevExercise? {
        if let prevExercise = workoutSessionViewModel.workoutSession?.prevExercises.first(where: { $0.exerciseRoutineId == exerciseRoutineId}) {
            return prevExercise
        }
        return nil
    }
    
    var body: some View {
        
        Group {
            
            if workoutSessionViewModel.isLoading {
                
                ProgressView()
                
            } else {
                if let workoutSession = Binding<WorkoutSession>($workoutSessionViewModel.workoutSession) {
                    List {
                        ForEach(workoutSession.exercises) { exercise in
                            EditExercise(
                                textObserver: TextFieldObserver(text: exercise.wrappedValue.notes),
                                exercise: exercise,
                                prevExercise: getPrevExercise(exerciseRoutineId: exercise.exerciseRoutine.id),
                                onDelete: {
                                    workoutSessionViewModel.getWorkoutSession(workoutSessionId: workoutSessionId, withNetwork: true)
                                }
                            )
                            .listRowInsets(EdgeInsets())
                            .padding(.bottom, 8)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                        }
                        HStack {
                            Spacer()
                            Button("Add Exercise") { showSheet = true }
                            .buttonStyle(RoundedButton())
                            .sheet(isPresented: $showSheet) {
                                SelectExerciseRoutine(
                                    workoutSessionId: workoutSession.id,
                                    workoutRoutineId: workoutSession.workoutRoutine.id,
                                    onSelectExerciseRoutine: {
                                        workoutSessionViewModel.getWorkoutSession(workoutSessionId: workoutSessionId, withNetwork: true)
                                    },
                                    showSheet: $showSheet
                                ).presentationDetents([.medium])
                            }
                            Spacer()
                        }.listRowSeparator(.hidden)
                    }.listStyle(.plain).refreshable {
                        workoutSessionViewModel.getWorkoutSession(workoutSessionId: workoutSessionId, withNetwork: true)
                    }
                    .alert(isPresented: $showFinishWorkoutAlert) {
                        Alert(
                            title: Text("Are you sure you want to finish this workout?"),
                            primaryButton: .default(Text("Confirm"), action: {
                                workoutSessionViewModel.finishWorkoutSession(id: workoutSessionId)
                                self.presentationMode.wrappedValue.dismiss()
                                showFinishWorkoutAlert = false
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                    
                } else {
                    
                    Text("Nothing here")
                    
                }
                
            }

        }.onAppear {
            workoutSessionViewModel.getWorkoutSession(workoutSessionId: workoutSessionId)
        }
        .navigationBarItems(trailing: end == nil ?  Button("Finish", action: {
            showFinishWorkoutAlert = true
        }) : nil)
        
    }
}

struct EditWorkoutSession_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkoutSession(workoutSessionId: "1")
    }
}
