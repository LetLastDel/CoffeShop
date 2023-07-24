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
            print("Не записалось \(error.localizedDescription)")
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
        print("Ордер пошел")
            try await addPosition(order.positions, to: order.id)
    }
    func getOrders(by userID: String?) async throws -> [OrderModel] {
        var orderList = [OrderModel]()
        let snapShot = try await ordersRef.getDocuments()
        let docs = snapShot.documents
        for doc in docs {
            if let userID{
                if let order = OrderModel(qdSnap: doc ), order.userID == userID
                { orderList.append(order)
                    print("Пошло через юзера")
                    print("Добавлено \(orderList.count)")
                }
            }else {
                if let order = OrderModel(qdSnap: doc )  { orderList.append(order) }
                print("Пошло общее")
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
    
    func addFavorite(_ menu: MenuModel, to profile: ProfileModel) async throws -> MenuModel {
        try await profilesRef.document(profile.id).collection("menu").document(menu.id).setData(menu.representation)
        return menu
    }
    func getFavorite(userID: String) async throws -> [MenuModel] {
        let snapShot = try await profilesRef.document(userID).collection("menu").getDocuments()
        let docs = snapShot.documents
        var menuList = [MenuModel]()
        for doc in docs {
            if let menu = MenuModel(qdSnap: doc) { menuList.append(menu) }
        }
        return menuList
    }
    func removeFavorite(userID: String, menu: MenuModel) async throws {
        try await profilesRef.document(userID).collection("menu").document(menu.id).delete()
        print("delete")
    }
    func addProduct(product: MenuModel, photo: Data) async throws {
        do{
            try await FireStoreStorage.shared.addImage(image: photo, productID: product.id, reference: FireStoreStorage.shared.productsRef)
            try await menuRef.document(product.id).setData(product.representation)

        } catch {
            print("Картинка не ушла")
        }
            print("uploaded")
    }
    func addCafes(coffeShop: CoffeShopModel, photo: Data) async throws {
        do{
            try await FireStoreStorage.shared.addImage(image: photo, productID: coffeShop.id, reference: FireStoreStorage.shared.caffesRef)
            try await coffeShopRef.document(coffeShop.id).setData(coffeShop.representation)
        } catch {
            print("Картинка не ушла")
        }
            print("uploaded")
        }
    func getMenu() async throws -> [MenuModel] {
        let snapShot = try await menuRef.getDocuments()
        let docs = snapShot.documents
        var menuList = [MenuModel]()
        for doc in docs {
            if let menu = MenuModel(qdSnap: doc) { menuList.append(menu) }
        }
        return menuList
    }

    func getShop() async throws -> [CoffeShopModel] {
        let snapShot = try await coffeShopRef.getDocuments()
        let docs = snapShot.documents
        var shopList = [CoffeShopModel]()
        for doc in docs {
            if let cshop = CoffeShopModel(qdSnap: doc) { shopList.append(cshop) }
        }
        return shopList
    }
    func removeItemorShop(id: String, reference: CollectionReference) async throws {
        try await reference.document(id).delete()
    }
}

    
