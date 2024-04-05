//
//  TWContentManager_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation
import CoreData

final class TWContentManager_MTW: NSObject {
     
     private let pageSize: Int = 4
     
     lazy var managedContext: NSManagedObjectContext = {
          persistentContainer.viewContext
     }()
     
     private lazy var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "TWContentCache_MTW")
          container.loadPersistentStores { description, error in
               if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
               }
          }
          return container
     }()
     
     func serialize(data: Data, for contentType: TWContentType_MTW) {
          switch contentType {
          case .editor: break
          case .guide:
               store(serialized(guide: data))
          case .sound:
               store(serialized(sound: data))
          default:
               store(serialized(data: data, for: contentType))
          }
     }
     
     func getPath_MTW(for contentType: TWContentType_MTW, imgPath: String) -> String {
          String(format: "/%@/%@", contentType.associatedPath.rawValue, imgPath)
     }
     
     
     func serialized(markups data: Data) -> [TWEditorMarkup_MTW] {
          if let jsonObj = jsonObj(from: data, with: "editor_list"),
             let markups = try? JSONDecoder().decode([TWEditorMarkup_MTW].self,
                                                     from: jsonObj) {
               return markups
          }
          
          return []
     }
     
     func serialize(markup: TWEditorMarkup_MTW,
                    data: Data) -> [TWEditorContentModel_MTW] {
          var content = [TWEditorContentModel_MTW]()
          do {
               let set = try JSONDecoder().decode(TWEditorCodableMarkupSet_MTW.self,
                                                  from: data)
               if let markup = stored(codable: set.markup, for: markup) {
                    content.append(markup)
               }
               
               content.append(contentsOf: stored(codable: set.hair,for: .hair, with: markup.id))
               content.append(contentsOf: stored(codable: set.eyebrows, for: .eyebrows, with: markup.id))
               content.append(contentsOf: stored(codable: set.bags, for: .bags, with: markup.id))
               content.append(contentsOf: stored(codable: set.trousers, for: .trousers, with: markup.id))
               content.append(contentsOf: stored(codable: set.shorts, for: .shorts, with: markup.id))
               content.append(contentsOf: stored(codable: set.eyes, for: .eyes, with: markup.id))
               content.append(contentsOf: stored(codable: set.nose, for: .nose, with: markup.id))
               content.append(contentsOf: stored(codable: set.shirt, for: .shirt, with: markup.id))
               content.append(contentsOf: stored(codable: set.shoes, for: .shoes, with: markup.id))
               content.append(contentsOf: stored(codable: set.skirts, for: .skirts, with: markup.id))
               content.append(contentsOf: stored(codable: set.dresses, for: .dresses, with: markup.id))
               content.append(contentsOf: stored(codable: set.mouth, for: .mouth, with: markup.id))
               
               return content
               
          } catch let error as NSError {
               print(error.localizedDescription)
               return []
          }
     }
     
     func isContentReady(for contentType: TWContentType_MTW) -> Bool {
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.predicate = .init(format: "contentType == %i",
                                         contentType.int64)
          do {
               return try managedContext.count(for: fetchRequest) != .zero
          }  catch let error as NSError {
               print(error.localizedDescription)
               return false
          }
     }
     
     func fetchContent(contentType: TWContentType_MTW,
                       category: TWContentItemCategory_MTW = .all,
                       page: Int = 1) -> [TWContentModel_MTW] {
          let fetchRequest = ContentEntity.fetchRequest()
          
          switch category {
          case .all:
               fetchRequest.predicate = .init(format: "contentType == %i",
                                              contentType.int64)
          case .stared:
               fetchRequest.predicate = .init(format: "contentType == %i AND contentStared == YES",
                                              contentType.int64)
          case .lastAdded:
               fetchRequest.predicate = .init(format: "contentType == %i",
                                              contentType.int64)
               fetchRequest.sortDescriptors = [.init(key: "timestamp",
                                                     ascending: false)]
          case .custom(let contentCategory):
               fetchRequest.predicate = .init(format: "contentType == %i AND contentCategory == %@",
                                              contentType.int64,
                                              contentCategory)
          }
          
          fetchRequest.fetchLimit = pageSize * page
          
          do {
               let result = try managedContext.fetch(fetchRequest)
               
               return result.compactMap { TWContentModel_MTW(from: $0) }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
          
     }
     
     func fetchCharacters(page: Int = 1) -> [TWCharacterPreview_MTW] {
          let fetchRequest = CharacterEntity.fetchRequest()
          
          fetchRequest.fetchLimit = pageSize * page
          
          do {
               return try managedContext
                    .fetch(fetchRequest)
                    .compactMap { TWCharacterPreview_MTW(from: $0) }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
     }
     
     func fetchEditorContent() -> [TWEditorContentModel_MTW] {
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.predicate = .init(format: "contentType == %i",
                                         TWContentType_MTW.editor.int64)
          
          do {
               return try managedContext
                    .fetch(fetchRequest)
                    .compactMap { TWEditorContentModel_MTW(from: $0) }
          } catch let error as NSError {
               print(error.localizedDescription)
               return []
          }
     }
     
     func removeEditorContent() {
         let fetchRequest = ContentEntity.fetchRequest()
         fetchRequest.predicate = .init(format: "contentType == %i", TWContentType_MTW.editor.int64)

         do {
             let editorContent = try managedContext.fetch(fetchRequest)
             for content in editorContent {
                 managedContext.delete(content)
             }

             try managedContext.save()
             print("Editor content removed successfully.")
         } catch let error as NSError {
             print("Error removing editor content: \(error.localizedDescription)")
         }
     }
     
     func getAllContentEntities() -> [ContentEntity] {
         let fetchRequest = NSFetchRequest<ContentEntity>(entityName: "ContentEntity")
         
         do {
             let contentEntities = try managedContext.fetch(fetchRequest)
             return contentEntities
         } catch let error as NSError {
             print("Error fetching ContentEntity objects: \(error.localizedDescription)")
             return []
         }
     }
     
     func removeAllContentEntities() {
         let fetchRequest = ContentEntity.fetchRequest()
         
         do {
             let contentEntities = try managedContext.fetch(fetchRequest)
             
             for contentEntity in contentEntities {
                 managedContext.delete(contentEntity)
             }
             
             saveContext()
             print("All ContentEntity objects removed successfully.")
         } catch let error as NSError {
             print("Error removing ContentEntity objects: \(error.localizedDescription)")
         }
     }

     
     func removeAllCharacters() {
         let fetchRequest = CharacterEntity.fetchRequest()
         
         do {
             let characters = try managedContext.fetch(fetchRequest)
             
             for character in characters {
                 managedContext.delete(character)
             }
             
             saveContext()
             print("All characters removed successfully.")
         } catch let error as NSError {
             print("Error removing characters: \(error.localizedDescription)")
         }
     }
     
     func fetchContent(contentType: TWContentType_MTW,
                       with searchText: String) -> [TWContentModel_MTW] {
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.predicate = .init(format: "contentType == %i AND contentName CONTAINS[cd] %@",
                                         contentType.int64,
                                         searchText)
          do {
               let result = try managedContext.fetch(fetchRequest)
               
               return result.compactMap { TWContentModel_MTW(from: $0) }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
     }
     
     func fetchCategories(for contentType: TWContentType_MTW) -> [String] {
          let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "ContentEntity")
          fetchRequest.predicate = .init(format: "contentType == %i",
                                         contentType.int64)
          fetchRequest.resultType = .dictionaryResultType
          fetchRequest.returnsDistinctResults = true
          fetchRequest.propertiesToFetch = ["contentCategory"]
          
          do {
               let result = try managedContext.fetch(fetchRequest)
               
               return result.compactMap { $0["contentCategory"] as? String }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
     }
     
     func fetchRecomendation(for contentType: TWContentType_MTW,
                             exclude id: UUID,
                             limit: Int) -> [TWContentModel_MTW] {
          let contentTypePredicate = NSPredicate(format: "contentType == %i",
                                                 contentType.int64)
          let excludePerdicate = NSPredicate(format: "%K != %@", "id",
                                             id as CVarArg)
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.fetchLimit = limit
          fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
               contentTypePredicate,
               excludePerdicate
          ])
          
          do {
               let result = try managedContext.fetch(fetchRequest)
               
               return result.compactMap { TWContentModel_MTW(from: $0) }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
     }
     
     func store(model: TWContentModel_MTW, data: Data?) {
          guard let data else { return }
          
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "%K == %@", "id",
                                               model.id as CVarArg)
          fetchRequest.fetchLimit = 1
          
          let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
          privateContext.persistentStoreCoordinator = managedContext.persistentStoreCoordinator
          
          do {
               let result = try privateContext.fetch(fetchRequest)
               
               if let exitingItem = result.first {
                    exitingItem.primaryData = data
               }
               
               if privateContext.hasChanges {
                    try privateContext.save()
               }
               
          } catch let error as NSError {
               print(error.localizedDescription)
               privateContext.rollback()
          }
     }
     
     func update(modelId id: UUID, isFavourite contentStared: Bool) {
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "%K == %@", "id",
                                               id as CVarArg)
          fetchRequest.fetchLimit = 1
          
          do {
               let result = try managedContext.fetch(fetchRequest)
               
               if let exitingItem = result.first {
                    exitingItem.contentStared = contentStared
               }
               
               saveContext()
          } catch let error as NSError {
               print(error.localizedDescription)
               managedContext.rollback()
          }
     }
     
     func store(model: TWEditorContentModel_MTW, data: Data?, preview: Data?) {
          guard let data,
                let preview else { return }
          
          let fetchRequest = ContentEntity.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "%K == %@", "id",
                                               model.id as CVarArg)
          fetchRequest.fetchLimit = 1
          
          let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
          privateContext.persistentStoreCoordinator = managedContext.persistentStoreCoordinator
          
          do {
               let result = try privateContext.fetch(fetchRequest)
               
               if let exitingItem = result.first {
                    exitingItem.primaryData = data
                    exitingItem.secondaryData = preview
               }
               
               if privateContext.hasChanges {
                    try privateContext.save()
               }
               
          } catch let error as NSError {
               print(error.localizedDescription)
               privateContext.rollback()
          }
     }
     
     func store(character preview: TWCharacterPreview_MTW) {
          let fetchRequest = CharacterEntity.fetchRequest()
          fetchRequest.predicate = .init(format: "%K == %@", "id",
                                         preview.id as CVarArg)
          fetchRequest.fetchLimit = 1
          
          do {
               if let entity = try managedContext.fetch(fetchRequest).first {
                    entity.color = preview.colorString
                    entity.markup = preview.markup
                    entity.content = preview.content
                    entity.eyebrows = preview.eyebrows
                    entity.eyes = preview.eyes
                    entity.hair = preview.hair
                    entity.hat = preview.hat
                    entity.mouth = preview.mouth
                    entity.nose = preview.nose
                    entity.shoes = preview.shoes
                    entity.top = preview.top
                    entity.bottom = preview.bottom
                    entity.accessory = preview.accessory
               } else {
                    let entity = CharacterEntity(context: managedContext)
                    entity.id = preview.id
                    entity.color = preview.colorString
                    entity.markup = preview.markup
                    entity.content = preview.content
                    entity.eyebrows = preview.eyebrows
                    entity.eyes = preview.eyes
                    entity.hair = preview.hair
                    entity.hat = preview.hat
                    entity.mouth = preview.mouth
                    entity.nose = preview.nose
                    entity.shoes = preview.shoes
                    entity.top = preview.top
                    entity.bottom = preview.bottom
                    entity.accessory = preview.accessory
               }
               
               saveContext()
          } catch let error as NSError {
               print(error.localizedDescription)
          }
     }
     
     func delete(character preview: TWCharacterPreview_MTW) {
          let fetchRequest = CharacterEntity.fetchRequest()
          fetchRequest.predicate = .init(format: "%K == %@", "id",
                                         preview.id as CVarArg)
          fetchRequest.fetchLimit = 1
          
          do {
               if let entity = try managedContext.fetch(fetchRequest).first {
                    managedContext.delete(entity)
               }
          } catch let error as NSError {
               print(error.localizedDescription)
               managedContext.rollback()
          }
     }
     
}

// MARK: - Private API

private extension TWContentManager_MTW {
     
     func jsonObj(from data: Data, with key: String) -> Data? {
          if let jsonDict = jsonDict(from: data),
             let jsonObj = jsonDict[key],
             let data = try? JSONSerialization.data(withJSONObject: jsonObj) {
               return data
          }
          
          return nil
     }
     
     func jsonDict(from data: Data) -> [String: Any]? {
          try? JSONSerialization.jsonObject(with: data) as? [String: Any]
     }
     
     func serialized(data: Data, for contentType: TWContentType_MTW)
     -> [TWContentModel_MTW] {
          var itemsToAdd = [TWContentModel_MTW]()
          do {
               let existingContent = existingContentIds(for: contentType)
               let categories = try JSONDecoder().decode(TWContentCodable_MTW.self,
                                                         from: data)
               categories.list.forEach { category in
                    itemsToAdd
                         .append(contentsOf: serialized(category: category,
                                                        existindIds: existingContent,
                                                        contentType: contentType))
               }
          } catch let error {
               print(error.localizedDescription)
          }
          
          return itemsToAdd
     }
     
     func serialized(category: TWContentCategoryCodable_MTW,
                     existindIds: [Int],
                     contentType: TWContentType_MTW) -> [TWContentModel_MTW] {
          var itemsToAdd = [TWContentModel_MTW]()
          for item in category.list where !existindIds.contains(item.id) {
               if let newContent = TWContentModel_MTW
                    .init(from: item,
                          contentType: contentType,
                          category: category.title) {
                    itemsToAdd.append(newContent)
               }
          }
          return itemsToAdd
     }
     
     func serialized(guide data: Data) -> [TWContentModel_MTW] {
          var itemsToAdd = [TWContentModel_MTW]()
          do {
               let existingContent = existingContentIds(for: .guide)
               let guides = try JSONDecoder().decode(TWGuidesCodable_MTW.self,
                                                     from: data)
               for item in guides.list where !existingContent.contains(item.id) {
                    if let newContent = TWContentModel_MTW(from: item,
                                                           contentType: .guide) {
                         itemsToAdd.append(newContent)
                    }
               }
          } catch let error {
               print(error.localizedDescription)
          }
          return itemsToAdd
     }
     
     func serialized(sound data: Data) -> [TWContentModel_MTW] {
          var itemsToAdd = [TWContentModel_MTW]()
          do {
               let existingContent = existingContentIds(for: .sound)
               let souds = try JSONDecoder().decode(TWSoundCodable_MTW.self,
                                                    from: data)
               for item in souds.list where !existingContent.contains(item.id) {
                    itemsToAdd.append(.init(from: item))
               }
          } catch let error {
               print(error.localizedDescription)
          }
          return itemsToAdd
     }
     
     func existingContentIds(for contentType: TWContentType_MTW) -> [Int] {
          let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "ContentEntity")
          fetchRequest.predicate = NSPredicate(format: "contentType == %i",
                                               contentType.int64)
          fetchRequest.propertiesToFetch = ["contentId"]
          fetchRequest.resultType = .dictionaryResultType
          
          do {
               let entities: [NSDictionary] = try managedContext.fetch(fetchRequest)
               
               return entities.compactMap { $0["contentId"] as? Int }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
     }
     
     func existingEditorContentIds(for markupId: Int,
                                   contentType: TWEditorContentType_MTW) -> [Int] {
          let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "ContentEntity")
          fetchRequest.propertiesToFetch = ["contentId"]
          fetchRequest.resultType = .dictionaryResultType
          fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
               .init(format: "contentType == %i",
                     TWContentType_MTW.editor.int64),
               .init(format: "editorContentType == %@",
                     contentType.rawValue),
               .init(format: "editorTag == %i",
                     markupId),
          ])
          
          do {
               let entities: [NSDictionary] = try managedContext.fetch(fetchRequest)
               
               return entities.compactMap { $0["contentId"] as? Int }
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return []
          }
     }
     
     func existingEditorContentModelId(for markupId: Int,
                                     contentType: TWEditorContentType_MTW,
                                       contentId: Int) -> UUID? {
          let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "ContentEntity")
          fetchRequest.propertiesToFetch = ["id"]
          fetchRequest.resultType = .dictionaryResultType
          fetchRequest.fetchLimit = 1
          fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
               .init(format: "contentType == %i", TWContentType_MTW.editor.int64),
               .init(format: "editorContentType == %@", contentType.rawValue),
               .init(format: "editorTag == %i", markupId),
               .init(format: "contentId == %i", contentId)
          ])
          
          do {
               let entities: [NSDictionary] = try managedContext.fetch(fetchRequest)
               
               return entities.first?.value(forKey: "id") as? UUID
          } catch let error as NSError {
               print(error.localizedDescription)
               
               return nil
          }
     }

     
     func store(_ models: [TWContentModel_MTW]) {
          if models.isEmpty { return }
          
          for model in models {
               let entity = ContentEntity(context: managedContext)
               entity.id = model.id
               entity.contentCategory = model.attributes?.category
               entity.contentDescription = model.content.description
               entity.contentId = Int64(model.content.contentId)
               entity.contentName = model.content.displayName
               entity.contentType = model.contentType.int64
               entity.primaryPath = model.content.path
               entity.timestamp = model.attributes?.timestamp
               entity.contentCategory = model.attributes?.category
               entity.newContent = model.attributes?.new ?? false
          }
          
          saveContext()
     }
     
     func stored(codable models: [TWEditorCodableContent_MTW]?,
                 for contentType: TWEditorContentType_MTW,
                 with markupId: Int) -> [TWEditorContentModel_MTW] {
          guard let models else { return [] }
          var content: [TWEditorContentModel_MTW] = []
          
          let existingContentIds = existingEditorContentIds(for: markupId,
                                                            contentType: contentType)
          
          for model in models {
               var parentId: UUID?
               
               if !existingContentIds.contains(model.id) {
                    let entity = ContentEntity(context: managedContext)
                    entity.id = UUID()
                    entity.contentId = Int64(model.id)
                    entity.contentType = TWContentType_MTW.editor.int64
                    entity.editorContentType = contentType.rawValue
                    entity.editorTag = Int64(markupId)
                    entity.primaryPath = model.path
                    entity.secondaryPath = model.preview
                    
                    saveContext()
                    
                    parentId = entity.id
                    
                    content.append(.init(from: entity))
               }
               
               guard let list = model.list,
                     let childContentType = contentType.childContentType else {
                    continue
               }
               
               if parentId == nil {
                    parentId = existingEditorContentModelId(
                         for: markupId,
                         contentType: childContentType,
                         contentId: model.id)
               }
               
               guard let parentId else { continue }
               
               let existingChildContentIds = existingEditorContentIds(
                    for: markupId,
                    contentType: childContentType)
               
               for item in list where !existingChildContentIds.contains(item.id) {
                    let entity = ContentEntity(context: managedContext)
                    entity.id = UUID()
                    entity.contentId = Int64(item.id)
                    entity.contentType = TWContentType_MTW.editor.int64
                    entity.editorContentType = childContentType.rawValue
                    entity.editorTag = Int64(markupId)
                    entity.primaryPath = item.path
                    entity.secondaryPath = item.preview
                    entity.parentId = parentId
                    
                    saveContext()
                    
                    content.append(.init(from: entity))
               }
          }
          
          return content
     }
     
     func stored(codable: TWEditorMarkupCodableContent_MTW,
                 for markup: TWEditorMarkup_MTW) -> TWEditorContentModel_MTW? {
          let existingContentIds = existingEditorContentIds(for: markup.id,
                                                            contentType: .markup)
          if existingContentIds.contains(markup.id) { return nil }
          
          let entity = ContentEntity(context: managedContext)
          entity.id = UUID()
          entity.contentType = TWContentType_MTW.editor.int64
          entity.editorContentType = TWEditorContentType_MTW.markup.rawValue
          entity.contentId = Int64(markup.id)
          entity.editorTag = Int64(markup.id)
          entity.primaryPath = codable.path
          entity.secondaryPath = codable.preview
          
          saveContext()
          
          return TWEditorContentModel_MTW(from: entity)
     }
     
     func execute(deleteRequest: NSBatchDeleteRequest) -> Bool {
          do {
               try managedContext.execute(deleteRequest)
               return true
          } catch let error {
               print(error.localizedDescription)
               managedContext.rollback()
               return false
          }
     }
     
     func saveContext() {
          guard managedContext.hasChanges else {
               return
          }
          
          do {
               try managedContext.save()
          } catch let error as NSError {
               print(error.localizedDescription)
               managedContext.rollback()
          }
     }
}
