//
//  TaskRowView.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 11.01.2024.
//

import SwiftUI

struct TaskRowView: View {
    
    @Binding var task: TaskPlanner
    
    @State var showMore: Bool = false
    
    var deleteTask: () -> ()
    var compltedTask: () -> ()
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(task.isComleted ? Color(uiColor: UIColor(hexString: "#EA838A")) : Color.backgroundColor)                .frame(width: 14, height: 14)
                .padding(1.5)
                .background(Color.blackOrWhiteColor.shadow(.drop(color: .black.opacity(0.1), radius: 0.5)), in: Circle())
                .padding(.leading, 0.25)
                .overlay {
                    Circle()
                        .fill(Color.backgroundColor)
                        .frame(width: 50, height: 50) // область для добавление жеста
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation {
                                task.isComleted.toggle()
                                compltedTask()
                            }
                        }
                }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.taskTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .strikethrough(task.isComleted, pattern: .solid, color: .black)
                    
                    Label(task.creationDate.format("HH:mm"), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.5))
                    
                    if showMore {
                        VStack {
//                            Text("Подробное описание и тд")
                            Button(action: {
                                deleteTask()
                            }, label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.red)
//                                Text("Удалить задачу")
//                                    .foregroundStyle(Color.white)
//                                    .padding(4)
//                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.red, lineWidth: 2))
                            })

                        }
                    }
                }
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showMore.toggle()
                    }
                } label: {
                    Image(systemName: showMore ? "arrow.up" : "arrow.down")
                        .foregroundStyle(Color.white)
//                    Text(showMore ? "Закрыть" : "Открыть")
                }
            }
            .padding(15)
            .hSpacing(.leading)
            .background(task.tint, in: RoundedRectangle(cornerRadius: 16))
            .offset(y: -8)
//            .onTapGesture {
//                task.isComleted.toggle()
//            }
        }
    }
    
    var indicatorColor: Color {
        if task.isComleted {
            return .green
        }
        
        return task.creationDate.isSameHour ? .blue : (task.creationDate.isPast ? .red : .black)
    }
}

//struct TaskRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRowView(task: Task(taskTitle: "13", tint: .blue))
//    }
//}
