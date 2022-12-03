//
//  ExerciseRoutinesList.swift
//  WorkoutLogger
//
//  Created by Neil Viloria on 2022-11-29.
//

import SwiftUI

struct ExerciseRoutineList: View {
    var exerciseRoutines: [ExerciseRoutine]
    
    var body: some View {

        ScrollView {
            
            if exerciseRoutines.count > 0 {
                   
                ForEach(exerciseRoutines, id: \.self.id) { exerciseRoutine in
                    
                    ExerciseRoutineListItem(name: exerciseRoutine.name, sets: exerciseRoutine.sets, reps: exerciseRoutine.reps)
                    
                }
                
            } else {

                Text("You don't have any exercise routines here, tap the Edit button to add some")
                    .foregroundColor(.tertiaryText)
                    .multilineTextAlignment(.center)
                    .padding()

            }
            
        }.padding()
        
    }

}

struct ExerciseRoutineList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRoutineList(exerciseRoutines: [ExerciseRoutine(
            id: "1",
            name: "Squat",
            sets: 4,
            reps: 5
        )]).preferredColorScheme(.dark)
    }
}