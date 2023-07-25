//
//  FireStoreService.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 17.07.2023.
//

import Foundation
import FirebaseFirestore

class FireStoreService {
    
    static let shared = FireStoreService(); private init() { }
    let db = Firestore.firestore()
    
    var profilesRef: CollectionReference {
        db.collection("profiles")
    }
    var menuRef: CollectionReference {
        db.collection("menu")
    }
    var coffeShopRef: CollectionReference {
        db.collection("coffeShop")
    }
    var ordersRef: CollectionReference {
        db.collection("order")
    }
    var positionRef: CollectionReference {
        db.collection("position")
    }
    
    func createProfile(profile: ProfileModel) async throws {
        do{
            try await profilesRef.document(profile.id).setData(profile.representation)
        } catch {
            throw Errors.singUpError
        }
    }
    func getProfile(by userID: String) async throws -> ProfileModel {
        let snapShot = try await profilesRef.document(userID).getDocument()
        guard let data = snapShot.data() else { throw FirestoreErrorCode(.dataLoss) }
        
        guard let profile = ProfileModel(data: data) else { throw FirestoreErrorCode(.invalidArgument)}
        
        return profile
    }
    func setProfile(profile: ProfileModel, dict: Dictionary<String, Any>) async throws {
        do{
            try await profilesRef.document(profile.id).setData(dict)
        } catch {
            print("Не записалось \(error.localizedDescription)")
        }
    }
    func changeOrderStatus(order: OrderModel, status: String) async throws {
        var ordr = order
        ordr.status = status
        try await ordersRef.document(ordr.id).setData(ordr.representation)
        try await self.addPosition(ordr.positions, to: ordr.id)
    }
    func addPosition(_ position: [PositionModel], to orderId: String) async throws {
        for pos in position{
            try await ordersRef.document(orderId).collection("position").document(pos.id).setData(pos.repsesentation)
        }
    }
    func addOrder(order: OrderModel) async throws {
        try await ordersRef.document(order.id).setData(order.representation)
            try await addPosition(order.positions, to: order.id)
    }
    func getOrders(by userID: String?) async throws -> [OrderModel] {
        var orderList = [OrderModel]()
        let snapShot = try await ordersRef.getDocuments()
        let docs = snapShot.documents
        for doc in docs {
            if let userID{
                if let order = OrderModel(qdSnap: doc ), order.userID == userID {
                    orderList.append(order)
                }
            }else {
                if let order = OrderModel(qdSnap: doc )  {
                    orderList.append(order)
                }
            }
        }
        return orderList
    }
    func getPositions(by orderID: String) async throws -> [PositionModel]{
        let snapShot = try await ordersRef.document(orderID).collection("position").getDocuments()
        let docs = snapShot.documents
        var positionList = [PositionModel]()
        for doc in docs {
            if let position = PositionModel(qdSnap: doc) { positionList.append(position)}
        }
        return positionList
    }
    
    func addFavorite(_ menu: ProductModel, to profile: ProfileModel) async throws -> ProductModel {
        try await profilesRef.document(profile.id).collection("menu").document(menu.id).setData(menu.representation)
        return menu
    }
    func getFavorite(userID: String) async throws -> [ProductModel] {
        let snapShot = try await profilesRef.document(userID).collection("menu").getDocuments()
        let docs = snapShot.documents
        var menuList = [ProductModel]()
        for doc in docs {
            if let menu = ProductModel(qdSnap: doc) { menuList.append(menu) }
        }
        return menuList
    }
    func removeFavorite(userID: String, menu: ProductModel) async throws {
        try await profilesRef.document(userID).collection("menu").document(menu.id).delete()
    }
    func addProduct(product: ProductModel, photo: Data) async throws {
        do{
            try await FireStoreStorage.shared.addImage(image: photo, productID: product.id, reference: FireStoreStorage.shared.productsRef)
            try await menuRef.document(product.id).setData(product.representation)
        } catch {
            throw Errors.productAddError
        }
    }
    func addCafes(coffeShop: ShopModel, photo: Data) async throws {
        do{
            try await FireStoreStorage.shared.addImage(image: photo, productID: coffeShop.id, reference: FireStoreStorage.shared.caffesRef)
            try await coffeShopRef.document(coffeShop.id).setData(coffeShop.representation)
        } catch {
            throw Errors.coffeShopAddError
        }
    }
    func getMenu() async throws -> [ProductModel] {
        let snapShot = try await menuRef.getDocuments()
        let docs = snapShot.documents
        var menuList = [ProductModel]()
        for doc in docs {
            if let menu = ProductModel(qdSnap: doc) { menuList.append(menu) }
        }
        return menuList
    }

    func getShop() async throws -> [ShopModel] {
        let snapShot = try await coffeShopRef.getDocuments()
        let docs = snapShot.documents
        var shopList = [ShopModel]()
        for doc in docs {
            if let cshop = ShopModel(qdSnap: doc) { shopList.append(cshop) }
        }
        return shopList
    }
    func removeItemorShop(id: String, reference: CollectionReference) async throws {
        try await reference.document(id).delete()
    }
}

    
