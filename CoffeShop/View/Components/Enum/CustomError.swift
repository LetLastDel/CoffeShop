//
//  CustomError.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 25.07.2023.
//

import Foundation

enum Errors: String, Error {
    case shortPass = "Пароль короче 8 символов"
    case passNotConfirm = "Пароли не совпадают"
    case emptyLogin = "Логин пустой или не правильный"
    case singInError = "Ошибка аутентефикации, проверьте логин и пароль и попробуйте еще раз"
    case singUpError = "Ошибка регистрации, попробуйте еще раз"
    case imageAddError = "Ошибка добавления изображения"
    case productAddError = "Ошибка добавления или изменения товара"
    case coffeShopAddError = "Ошибка добавления или изменения магазина"
    case emptyChart = "Ваша корзина пуста!"
    case adressError = "Укажите свой номер телефона и адрес"
}
