//
//  NewTaskView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.01.2024.
//

import SwiftUI

struct NewTaskView: View {

    @ObservedObject var viewModel: PlannerViewModel
    @Environment(\.dismiss) private var dismiss

    /// View Properties
    
    @State var taskDate: Date = .init()
    @State private var taskTitle: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("BackArrowIcon")
                }
                Spacer()
                Button {
                    let newTask = TaskPlanner(taskTitle: taskTitle, creationDate: taskDate, tint: Color(uiColor: UIColor(hexString: "B0B0B0")))
                    viewModel.addNewTask(newTask)
                    dismiss()
                } label: {
                    Image("DoneIcon")
                }
                .disabled(taskTitle == "")
                .opacity(taskTitle == "" ? 0.5 : 1)
            }


            VStack(alignment: .leading, spacing: 8) {
                Text("Задача:")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("", text: $taskTitle)
                    .foregroundStyle(Color.mainGradientBackground)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(.white.shadow(.drop(color: .black.opacity(0.3),radius: 2)).opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 5)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Дата:")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    DatePicker("", selection: $taskDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .accentColor(Color(uiColor: UIColor(hexString: "#EA838A")))
                        .environment(\.locale, Locale.init(identifier: "ru_RU"))
                        .datePickerStyle(.compact)
                }
            }
            .padding(.top, 5)

            Spacer(minLength: 0)

//            Button {
//                let newTask = TaskPlanner(taskTitle: taskTitle, creationDate: taskDate, tint: Color(uiColor: UIColor(hexString: "B0B0B0")))
//                viewModel.addNewTask(newTask)
////                viewModel.tasks.append(newTask)
//                dismiss()
//            } label: {
//                Text("Создать")
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                    .hSpacing(.center)
//                    .padding(.vertical, 12)
//                    .background(Color.mainGradientBackground, in: RoundedRectangle(cornerRadius: 10))
//            }
//            .disabled(taskTitle == "")
//            .opacity(taskTitle == "" ? 0.5 : 1)
        }
        .padding(16)
        .background(Color(uiColor: UIColor(hexString: "4C4B4B")).opacity(0.5))
    }
}



//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Task Color")
//                        .font(.caption)
//                        .foregroundStyle(.gray)
//
//                    let colors: [Color] = [.teal, .purple, .indigo, .brown, .orange]
//
//                    HStack(spacing: 0) {
//                        ForEach(colors, id: \.self) { color in
//                            Circle()
//                                .fill(color)
//                                .frame(width: 20, height: 20)
//                                .background(content: {
//                                    Circle()
//                                        .stroke(lineWidth: 2)
//                                        .opacity(taskColor == color ? 1 : 0)
//                                })
//                                .hSpacing(.center)
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    withAnimation(.easeOut) {
//                                        taskColor = color
//                                    }
//                                }
//                        }
//                    }
//                }
