
import SwiftUI

struct PlannerScreen: View {
    
    @StateObject var viewModel: PlannerViewModel
    
//    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
//    @State private var tasks: [TaskPlanner] = sampleTask.sorted(by: { $1.creationDate > $0.creationDate })
    @State private var createNewTask: Bool = false
    /// Animation Namespace
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
            ScrollView(.vertical) {
                VStack {
                    /// Tasks View
                    TasksView()
                        .padding(.trailing, 16)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        }
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button {
                createNewTask.toggle()
            } label: {
                Image(systemName: "plus")                        
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.mainGradientBackground)
                    .frame(width: 55, height: 55, alignment: .center)
                    .background(.black.opacity(0.5), in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.mainGradientBackground, lineWidth: 1)
                    )
            }
            .padding(15)

        })
        .onAppear {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        }
        .sheet(isPresented: $createNewTask) {
            NewTaskView(viewModel: viewModel)
//                .presentationDetents([.medium])
                .interactiveDismissDisabled()
                .presentationCornerRadius(24)
//                .presentationBackground(.yellow)
            
        }
        .task {
            await viewModel.fetchTasksFromCD()
            await viewModel.fetchTasks(by: viewModel.currentDate)
            await viewModel.deleteOldTasks()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
//            HStack(spacing: 5) {
//                Text(viewModel.currentDate.format("MMMM"))
//                    .foregroundStyle(.blue)
//                Text(viewModel.currentDate.format("YYYY"))
//                    .foregroundStyle(.gray)
//            }
//            .font(.title.bold())
            Text(viewModel.currentDate.format("EEEE, d MMMM yyyy"))
                .font(.callout)
                .fontWeight(.semibold)
//                .textScale(.secondary) not work?
                .foregroundStyle(.gray)
            
            /// Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .hSpacing(.leading)
//        .overlay(alignment: .topTrailing, content: {
//            Button {
//                print("123")
//            } label: {
//                Image("catAnn")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 45, height: 45)
//                    .clipShape(Capsule())
//            }
//
//        })
        .padding(15)
        .background(Color.backgroundColor)
        .onChange(of: currentWeekIndex) { newValue in
            /// Creating when it reaches first/last page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
//                    Text(day.date.format("E"))
//                        .font(.callout)
//                        .fontWeight(.medium)
////                        .textScale(.secondary) not work?
//                        .foregroundStyle(.gray)
            
                    Text(day.date.format("dd"))
                        .font(.caption)
                        .fontWeight(.medium)
//                        .textScale(.secondary) not work?
                        .foregroundStyle(isSameDate(day.date, viewModel.currentDate) ? .white : .gray)
                        .frame(width: 42, height: 42)
                        .background(content: {
                            if isSameDate(day.date, viewModel.currentDate) {
                                Circle()
                                    .fill(Color.mainGradientBackground)
//                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            /// Indicator to show^ Which is Today's date
                            if day.date.isToday {
                                Circle()
                                    .fill(Color.mainGradientBackground)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
//                        .background(.white.shadow(.drop(radius: 1)), in: Capsule())
                        .background(.clear)
//                        .border(Color.white, width: 1)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                .hSpacing(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    /// Updating current date
                    viewModel.currentDate = day.date
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        /// When the offset  reaches 15 and if the createWeek is toggle then simply generating next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    func paginateWeek() {
        /// SafeCheck
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting new week at 0th index and removing last array item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
    
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Appending new week at Last index and removing First array item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach($viewModel.tasks) { $task in
                TaskRowView(task: $task, deleteTask: {
                    withAnimation {
                        viewModel.delete(task)
                    }
                }, compltedTask: {
                    viewModel.complete(task)
                })
                        .background(alignment: .leading) {
                            if $viewModel.tasks.last?.id != task.id {
                                Rectangle()
                                    .fill(Color.mainGradientBackground)
                                    .frame(width: 1)
                                    .offset(x: 8)
                                    .padding(.bottom, -35)
                            }
                        }
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        .onChange(of: viewModel.currentDate) { newValue in
            Task {
               await viewModel.fetchTasks(by: newValue)
            }
        }
    }
}

