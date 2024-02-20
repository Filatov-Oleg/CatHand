//
//  InstagramViewModel.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 02.12.2023.
//

import Foundation
import PhotosUI
import CoreData

enum InstagramScreenState {
    case loading
    case content
}


class InstagramViewModel: ObservableObject {
    // MARK: Properties
    
    @Published var profileImage = UIImage(data: UserDefaultsService().userInfoInstagram?.imageData ?? Data()) ?? UIImage(named: "BackgroundImage")
    
    @Published var carouselType: СarouselImagesType = .image
    @Published var fetchedImages: [ImageAsset] = []
    var libraryImages: [ImageAsset] = []
    
    @Published var savedVideos: [ImageAsset] = ImageAsset.examples.reversed()
    @Published var savedPosts: [ImageAsset] = []
    @Published var storyImages: [ImageAsset] = []
    
    @Published var savedImagesIndex: Int = -1
    @Published var deleteImageIndex: Int = -1

    @Published var userInfo: UserInfoInstagram? = UserDefaultsService().userInfoInstagram
    
    private let mocContext: NSManagedObjectContext
    private var needCallSavePostsOrder: Bool = false
    
    var currentState: InstagramScreenState = .loading
    
    init(mocContext: NSManagedObjectContext) {
        self.mocContext = mocContext
//        fetchSavedStories()
    }
    
    // MARK: Fetching images
    func fetchImages() {
        switch carouselType {
        case .profile:
            self.fetchedImages.append(ImageAsset(thumbnail: profileImage))
        case .story:
            self.fetchedImages.append(storyImages[savedImagesIndex])
        case .image:
            self.fetchedImages.append(savedPosts[savedImagesIndex])
        case .video:
            self.fetchedImages.append((savedVideos[savedImagesIndex]))
        @unknown default:
            print("default Fetch image")
        }
        self.fetchedImages.append(contentsOf: Array(libraryImages.prefix(20)))
    }
    
    func fetchNextImages() {
        if libraryImages.count > fetchedImages.count + 20 {
            self.fetchedImages.append(contentsOf: Array(libraryImages[fetchedImages.count..<fetchedImages.count + 20]))
        } else if (libraryImages.count - fetchedImages.count) > fetchedImages.count {
            self.fetchedImages.append(contentsOf: Array(libraryImages[fetchedImages.count..<fetchedImages.count + (libraryImages.count - fetchedImages.count)]))
        }
    }
    
    func fetchImagesFromLibrary() async -> [ImageAsset] {
        let options = PHFetchOptions()
        // MARK: Modify as per yout wish
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        
//        options.fetchLimit = 150
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        var result: [ImageAsset] = []
        PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, count, _ in
            let imageAsset: ImageAsset = .init(asset: asset)
            result.append(imageAsset)
            //            self.fetchedImagesUUID.append(imageAsset.id)
        }
        print("Ready === \(result.count)")
        return result
    }
    
    func deleteItemImage() {
        switch carouselType {
        case .profile:
            profileImage = UIImage(named: "BackgroundImage")
        case .story:
            deleteStory()
        case .image:
            deletePost()
        case .video:
            break
        @unknown default:
            print("default Fetch image")
        }
    }
    
    func updateUserInfo(by userInfo: UserInfoInstagram) {
        self.userInfo = userInfo
        UserDefaultsService().userInfoInstagram = userInfo
        self.currentState = .content
    }
    
    func fetchAllImages() {
        let group = DispatchGroup()
        group.enter()
        fetchPosts {
            print("Success fetching posts")
            group.leave()
        }
        
        group.enter()
        fetchStories {
            print("Success fetching stories")
            group.leave()
        }

        let queueType = DispatchQueue.global(qos: .userInitiated)
        group.notify(queue: queueType) {
            print("DispatchGroup - notify: All task Finished.")
            self.currentState = .content
        }
    }
    
    // MARK: Posts
    
    func savePostsOrder() {
        if needCallSavePostsOrder {
            Task {
                await changePositionPostInCD()
            }
        }
    }
    
    func changePositionPost(draggingItem: ImageAsset, image: ImageAsset) {
        if let sourceIndex = savedPosts.firstIndex(of: draggingItem),
           let destinationIndex = savedPosts.firstIndex(of: image) {
            let sourceItem = savedPosts.remove(at: sourceIndex)
            savedPosts.insert(sourceItem, at: destinationIndex)
            needCallSavePostsOrder = true
        }
    }

    func addNewPost() {
        let newImageAsset = ImageAsset(thumbnail: UIImage(named: "BackgroundImage"))
        savedPosts.insert(newImageAsset, at: 0)
        Task {
            await addSavedPost(newImageAsset)
        }
    }

    func deletePost() {
        savedImagesIndex = -1
        let deletedPost = savedPosts.remove(at: deleteImageIndex)
        Task {
            await deleteSavedPost(with: deletedPost.id)
        }
        
    }
    
    func fetchPosts(completion: @escaping ()->()) {
        self.fetchSavedPosts { resultPosts in
            self.savedPosts = resultPosts
            completion()
        }
    }
    
    // MARK: Stories
    
    func addNewStory() {
        let newImageAsset = ImageAsset(thumbnail: UIImage(named: "BackgroundImage"), title: "История")
        storyImages.insert(newImageAsset, at: 0)
        Task {
            await addSavedStory(newImageAsset)
        }
    }

    func deleteStory() {
        savedImagesIndex = -1
        let deletedStory = storyImages.remove(at: deleteImageIndex)
        Task {
            await deleteSavedStory(with: deletedStory.id)
        }
    }


    func fetchStories(completion: @escaping ()->()) {
        self.fetchSavedStories { resultStories in
            self.storyImages = resultStories
            completion()
        }
    }
    
    func changeStory(_ text: String) {
        storyImages[savedImagesIndex].title = text
        Task {
            await updateStoryTitle(text)
        }

    }
    
    func updateData() {
        switch carouselType {
        case .profile:
            UserDefaultsService().userInfoInstagram?.imageData = profileImage?.jpegData(compressionQuality: 1.0) ?? Data()
        case .story:
            Task {
                await updateStoryImage()
            }
        case .image:
            Task {
                await updatePost()
            }
        case .video:
            print("video update")
        }
        self.fetchedImages.removeAll()
    }
}


// MARK: Core data for posts

extension InstagramViewModel {

    func fetchSavedPosts(succesCompletion: @escaping ([ImageAsset])->()) {
        if let savedPostsFromCD = try? mocContext.fetch(InstagramPost.fetchRequest()) {
            let result = savedPostsFromCD.map {ImageAsset(id: $0.id?.uuidString ?? "", thumbnail: UIImage(data: $0.imageData ?? Data()))}
            succesCompletion(result.reversed())
        }
    }
    
    func addSavedPost(_ story: ImageAsset) async {
        let newPost = InstagramPost(context: mocContext)
        newPost.id = UUID(uuidString: story.id)
        newPost.imageData = story.thumbnail?.jpegData(compressionQuality: 1.0)
        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }
    
    func updatePost() async {
        if savedImagesIndex >= 0 {
            let request = InstagramPost.fetchRequest()
            if let savedPostsFromCD = try? mocContext.fetch(request) {
                for savedPost in savedPostsFromCD {
                    if savedPosts[savedImagesIndex].id == savedPost.id?.uuidString {
                        savedPost.imageData = savedPosts[savedImagesIndex].thumbnail?.jpegData(compressionQuality: 1.0)
                        break
                    }
                }
            }
            
            if mocContext.hasChanges {
                try? mocContext.save()
            }
        }
    }
    
    func deleteSavedPost(with id: String) async {
        let request = InstagramPost.fetchRequest()
        if let savedPostsFromCD = try? mocContext.fetch(request) {
            for savedPost in savedPostsFromCD {
                if savedPost.id?.uuidString == id {
                    mocContext.delete(savedPost)
                    break
                }
            }
        }

        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }

    func changePositionPostInCD() async {
        if var savedPostsFromCD = try? mocContext.fetch(InstagramPost.fetchRequest()) {
            savedPostsFromCD.reverse()
            for i in 0..<savedPostsFromCD.count {
                savedPostsFromCD[i].imageData = savedPosts[i].thumbnail?.jpegData(compressionQuality: 1.0)
            }
        }
        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }
}



// MARK: Core data for stories

extension InstagramViewModel {

    func fetchSavedStories(succesCompletion: @escaping ([ImageAsset])->()) {
        if let savedStories = try? mocContext.fetch(InstagramStory.fetchRequest()) {
            let result = savedStories.map {ImageAsset(id: $0.id?.uuidString ?? "", thumbnail: UIImage(data: $0.imageData ?? Data()), title: $0.title ?? "История")}
            succesCompletion(result.reversed())
        }
    }
    
    func addSavedStory(_ story: ImageAsset) async {
        let newStory = InstagramStory(context: mocContext)
        newStory.id = UUID(uuidString: story.id)
        newStory.imageData = story.thumbnail?.jpegData(compressionQuality: 1.0)
        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }
    
    func updateStoryImage() async {
        if savedImagesIndex >= 0 {
            let request = InstagramStory.fetchRequest()
            if let savedStories = try? mocContext.fetch(request) {
                for savedStory in savedStories {
                    if storyImages[savedImagesIndex].id == savedStory.id?.uuidString {
                        savedStory.imageData = storyImages[savedImagesIndex].thumbnail?.jpegData(compressionQuality: 1.0)
                        break
                    }
                }
            }
            if mocContext.hasChanges {
                try? mocContext.save()
            }
        }
    }
    func updateStoryTitle(_ text: String) async {
        if savedImagesIndex >= 0 {
            let request = InstagramStory.fetchRequest()
            if let savedStories = try? mocContext.fetch(request) {
                for savedStory in savedStories {
                    if storyImages[savedImagesIndex].id == savedStory.id?.uuidString {
                        savedStory.title = text
                        break
                    }
                }
            }
            if mocContext.hasChanges {
                try? mocContext.save()
            }
        }
    }
    
    func deleteSavedStory(with id: String) async {
        let request = InstagramStory.fetchRequest()
        if let savedStories = try? mocContext.fetch(request) {
            for savedStory in savedStories {
                if savedStory.id?.uuidString == id {
                    mocContext.delete(savedStory)
                    break
                }
            }
        }

        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }
}
