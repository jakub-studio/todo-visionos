//
//  ContentView.swift
//  vision-playground
//

import SwiftUI

func getIconForPriority (priority: TodoItemPriority) -> String {
    switch priority {
    case .regular: return "minus"
    case .high: return "chevron.up"
    case .urgent: return "exclamationmark"
    }
}

func getColorForPriority (priority: TodoItemPriority) -> Color {
    switch priority {
    case .regular:
        return Color(hue: 0, saturation: 0, brightness: 1, opacity: 0.2)
    case .high:
        return .blue
    case .urgent: return .red
    }
}


struct ContentView: View {
    @AppStorage("tasks") var tasks = TodoItem.sampleData
    
    // Task related states
    @State private var pendingTodoItem: String = ""
    @FocusState private var pendingTodoItemIsFocused
    @State private var pendingTodoItemPriority: TodoItemPriority = TodoItemPriority.regular
    
    @State private var isDeleteAllDialogShown = false;
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center, content: {
                VStack(alignment: .leading, content: {
                    Text("My todos")
                        .font(.largeTitle)
                        .padding(.bottom, 2)
                    
                    
                    Text("Welcome back.")
                        .font(.subheadline)
                })
                
                Spacer()
                
                HStack(alignment: .center) {
                    Text(LocalizedStringKey("\(tasks.count) tasks"))
                        .font(.subheadline)
                    Image(systemName: "ellipsis.circle")
                }
                .padding()
                .contextMenu(ContextMenu(menuItems: {
                    Button(role: .destructive) {
                        self.isDeleteAllDialogShown = true
                    } label: {
                        Label("Delete all tasks", systemImage: "trash")
                    }
                }))
                
            })
            .padding(.horizontal, 32)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            .background()
            
            if $tasks.isEmpty {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "square.stack.3d.up.slash")
                        .font(.largeTitle.weight(.regular))
                        .padding()
                    Text("Job's a good'un")
                        .font(.title)
                        .padding(.bottom, 5)
                    Text("Go make yourself a tea, you earned it.")
                }.frame(maxWidth: .infinity).opacity(0.6)
                Spacer()
            } else {
                List {
                    ForEach(tasks, id: \.id) { task in
                        HStack {
                            Image(systemName: getIconForPriority(priority: task.priority))
                                .frame(width: 30, height: 30)
                                .background(getColorForPriority(priority: task.priority), in: .circle)
                            Text(task.description)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .padding(.vertical, 12)
                .confirmationDialog("Are you sure you want to delete all tasks?", isPresented: $isDeleteAllDialogShown, titleVisibility: .visible) {
                    Button("Delete all", role: .destructive) {
                        deleteAllTasks()
                    }
                }
            }
            
            HStack {
                Form {
                    TextField(
                        "Get my chores done",
                        text: $pendingTodoItem
                    )
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                }.formStyle(.columns)
                
                
                Button(action: cyclePriority) {
                    Image(systemName: getIconForPriority(priority: pendingTodoItemPriority))
                    
                }.tint(getColorForPriority(priority: pendingTodoItemPriority))
                    .buttonBorderShape(.circle)
                
                
                Button(action: addTask) {
                    Text("Add todo")
                }.buttonStyle(.borderedProminent)
                
                
                
            }.padding().background()
        }
    }
    
    func addTask() {
        if !pendingTodoItem.isEmpty {
            tasks.append(TodoItem(description: pendingTodoItem, priority: pendingTodoItemPriority))
            tasks.sort()
            pendingTodoItem = ""
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func deleteAllTasks () {
        tasks.removeAll()
    }
    
    func cyclePriority () {
        if (pendingTodoItemPriority == TodoItemPriority.regular) {
            pendingTodoItemPriority = TodoItemPriority.high;
            return;
        }
        
        if (pendingTodoItemPriority == TodoItemPriority.high) {
            pendingTodoItemPriority = TodoItemPriority.urgent;
            return;
        }
        
        if (pendingTodoItemPriority == TodoItemPriority.urgent) {
            pendingTodoItemPriority = TodoItemPriority.regular
            return;
        }
        
    }
}


#Preview(windowStyle: .automatic) {
    ContentView()
}
