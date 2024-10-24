//
//  ContentView.swift
//  CoreDataLearning
//
//  Created by MacBook on 24/10/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    @FetchRequest(
        entity: FruitsEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitsEntity.name, ascending: true)] 
    )
    private var fruits: FetchedResults<FruitsEntity>
    
    @State var textField: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack (spacing: 20) {
                
                TextField("Add fruit here...", text: $textField)
                    .padding(.horizontal)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Button("save fruit") {
                    guard !textField.isEmpty && !(textField.count < 3) else {return}
                    addItem(item: textField)
                    textField = ""
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue.cornerRadius(10))
                .padding(.horizontal)
                
                List {
                    ForEach(fruits) { fruit in
                        
                        Text(fruit.name!)
                            .onTapGesture {
                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            
            .navigationTitle("Fruits")
            .navigationBarItems(
                leading: EditButton()
            )
            

        }
        .onAppear{
//            if fruits.isEmpty {
//                do {
//                    for index in 0..<10 {
//                        let newFruit = FruitsEntity(context: viewContext)
//                        newFruit.name = "Apple \(index)"
//                    }
//                    try viewContext.save()
//                } catch {
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                }
//            }
        }
    }
    
    private func updateItem(fruit: FruitsEntity) -> Void {
        withAnimation {
            
            let oldName: String = fruit.name ?? ""
            let newName: String = oldName + "!"
            fruit.name = newName
            saveItems()
        }
    }

    private func addItem(item: String) {
        withAnimation {
            let fruit = FruitsEntity(context: viewContext)
            fruit.name = item
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else {return}
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)

            saveItems()
        }
    }
    
    private func saveItems() -> Void {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
     }

}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
