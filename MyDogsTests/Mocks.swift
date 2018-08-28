import Foundation
@testable import MyDogs

class Mocks {
    static let TEST_NAME = "Snowy"
    static let TEST_OWNER = "Tintin"
    static let TEST_BLURB = "Snowy is a fictional character in The Adventures of Tintin, the comics series by Belgian cartoonist Hergé. Snowy is a white Wire Fox Terrier who is a companion to Tintin, the series' protagonist. Milou, Snowy's original French name, was the nickname of Hergé's first girlfriend"
    
    static let Snowy = DogModel(
        name: "Snowy",
        owner: "Tintin",
        blurb: "Snowy is a fictional character in The Adventures of Tintin, the comics series by Belgian cartoonist Hergé. Snowy is a white Wire Fox Terrier who is a companion to Tintin, the series' protagonist. Milou, Snowy's original French name, was the nickname of Hergé's first girlfriend",
        sample: true
    )

    static let Toto = DogModel(
        name: "Toto",
        owner: "Dorothy",
        blurb: "Toto is the beloved and loyal companion of Dorothy Gale, the main heroine and protagonist of The Wizard of Oz. Toto was Dorothy's only friend and sole source of happiness and he would play with Dorothy all day, everyday, and keep her company on the lonely, isolated farmland",
        sample: true
    )


    static let dogModel1 = DogModel(
        name: "Name",
        owner: "Owner",
        blurb: "Blurb here",
        uuid: "123",
        sample: true)

}
